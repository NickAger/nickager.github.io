---
title: "Step 3: Using Nginx upload progress module"
date: 2011-07-01 11:03:00 +0000
tags: [Nginx, file, upload]
layout: post
---
In this step we describe how to add an upload progress bar to the file uploads. The Nginx documentation for the upload progress module can be found [here](http://wiki.nginx.org/HttpUploadProgressModule). This post builds on the code described in the [previous](File-upload-using-Nginx-and-Seaside-step-2) two [posts](File-upload-using-Nginx-and-Seaside-step-1).

## Parameterising and generifying the Javascript
In this step we chose to parameterise the Javascript; replacing hard coded element ids with parameters. Evolving the code in this way allows instantiation of  multiple file upload components on the same page. Pollution of the Javascript global namespace is minimised to a single shared method - `startUpload`. Finally the generic Javascript has been moved to a file library.

## Nginx configuration changes

Firstly we modify our Nginx configuration. At the bottom of the location  `fileupload` block add:

```
# file upload progress tracking - 30s is the timeout (progress tracking is
# available 30s after the upload has finished)
# this must be the last directive in the location block.
track_uploads proxied 30s;
```

and create a new location block to track progress:

```
# used to report upload progress - defined by the Nginx Upload Progress Module
# see http://wiki.nginx.org/HttpUploadProgressModule
location  /progress {
    report_uploads proxied;
}
```

This location block is key to reporting upload progress; once the upload has started, we poll `/progress` to receive updates on the upload status.

Within the main http block of the Nginx configuration add:

```
upload_max_file_size 10m;
upload_progress proxied 10m;
```

and ensure the sizes set match the `client_max_body_size` directive:

```
client_max_body_size 10m;
```

## Seaside modifications
According to the [upload progress documentation](http://wiki.nginx.org/HttpUploadProgressModule):

> The HTTP request to this location must have a X-Progress-ID parameter or HTTP header containing a valid unique identifier of an inprogress upload

Back in our Smalltalk class we add a helper method to generate a unique upload id:

```smalltalk
xProgressId
	^xProgressId ifNil: [ xProgressId := WAKeyGenerator current keyOfLength: 15 ]
```

and a reset:

```smalltalk
resetXProgressId
	xProgressId := nil
```

In the form we modify the `hiddenInput` to work twice as hard for us. To the callback processing we add a call to `#resetXProgressId`, and we store  `#xProgressId` in the `hiddenInput`'s value:

```smalltalk
renderUploadFormOn: html
	| formId |

	html form
		multipart;
		attributeAt: 'target' put: (iframeId := html nextId);
		id: (formId := html nextId);
		with: [
			| fileUploadField fileUploadId progressBarId notificationId |

			"The Nginx handler stores the file uploaded in a specified location and adds POST parameters
			for the filename, the size, the file type etc.
			These parameters are then interpreted by the server form handling code.
			Note: the file uploaded parameter (the file contents) is removed from the form variables."

			fileUploadField := html fileUpload
				id: (fileUploadId := html nextId);
				callback: [ :file |
					"should never get here as Nginx's upload file model removes the
					uploaded parameter from the form variables in the post request, so
					Seaside never fires the callback"
					self error: 'Check your Nginx configuration' ].

			html hiddenInput
				id: (hiddenXProgressId := html nextId);
				value: self xProgressId;			
				callback: [:val | | uploadFieldName |
					"what name did Seaside assign to the file upload form field?"
					uploadFieldName := fileUploadField attributeAt: 'name'.
					self storeUploadedFile: uploadFieldName.
					self resetXProgressId.
					self renderIFrameResponse ].		

			progressBarId := html nextId.
			notificationId := html nextId.
			uploadedFilesContainerId := html nextId.

        		html button
				bePush;
				onClick: ((JSStream on: 'window')
					call: 'startUpload'
					withArguments: (Array
						with: (html jQuery id: fileUploadId)
						with: (html jQuery id: formId)
						with: (html jQuery id: hiddenXProgressId)
						with: (html jQuery id: progressBarId)
						with: (html jQuery id: notificationId)));
				with: 'Upload File'.

			self renderUploadProgressBarOn: html progressBarId: progressBarId notificationId: notificationId ].

	self renderHiddenIFrameOn: html
```


Note that the hard coded ids in `renderUploadFormOn:` in the previous steps have been replaced with dynamically assigned local and instance variables which are used in other Javascript handlers to reference the form elements.

The form's submit button has changed to a push button with an `#onClick:` handler which calls a modified `startUpload` with parameters of JQuery references to various fields. Alternatively you could add an `#onChange:` handler to the `fileUpload` control and call `startUpload` from there, dispensing with the need for the button.

The Javascript function `startUpload` is defined as:

```javascript
function startUpload(fileUploadField, form, xProgressField, progressBar, notificationField) {
var filename = fileUploadField.val();
if (!filename && filename.length) {
	var xProgressId = xProgressField.val();
	var formActionUrl = form.attr("action");
	/* add X-Progress-ID parameter if its not already there otherwise replace it */
	if (formActionUrl.indexOf ("X-Progress-ID") == -1) {
		formActionUrl += "&X-Progress-ID=" + xProgressId;
	} else {
		formActionUrl = formActionUrl.replace(/^(.*X-Progress-ID=)(.*)(&.*)?$/, "$1" +xProgressId + "$3");
	}
	form.attr("action", formActionUrl);
	form.submit();

	fileUploadField.val("");
	}
}
```

On the first upload the javascript appends the `X-Progress-ID` to the URL. On subsequent uploads, the regular expression replaces the `X-Progress-ID` parameter's value with the current value set in the `xProgressField` hidden field.

We also add a line to `fileUploadedCallbackJSOn:` to set a new value of `#xProgressId=`after a file has been upload:

```smalltalk
fileUploadedCallbackJSOn: html
	^
'$("#', uploadedFilesContainerId, '").replaceWith($("#',iframeId,'").contents().find("#', uploadedFilesContainerId, '"));
$("#', hiddenXProgressId, '").val($("#',iframeId,'").contents().find("#newXProgressId").val())'
```

this method is called from:

```smalltalk
renderHiddenIFrameOn: html
	html iframe
		name: iframeId;
		id: iframeId;
		style: 'position:absolute;top:-1000px;left:-1000px'.

	html document addLoadScript:  ((html jQuery id: iframeId) onLoad: (self fileUploadedCallbackJSOn: html))
```

with the iframes `onload` handler being set dynamically at page load.

## Adding the progress bar
We've created the infrastructure for the upload progress bar, now we add the progress bar:

```smalltalk
renderUploadProgressBarOn: html progressBarId: progressBarId notificationId: notificationId
	html div
		id: progressBarId;
		style: 'display: none'; "It starts hidden"
		script: (html jQuery this progressbar value: 0).

	html div id: notificationId
```

Javascript support for polling `/progress` and reporting on status is added to `startUpload`. The code is now generic and I've chosen to move the method into a file library which is then referenced in `updateRoot:`

```smalltalk
updateRoot: anHtmlRoot
	super updateRoot: anHtmlRoot.
	anHtmlRoot javascript url: NAFileUploadStep3FileLibrary / #startUploadJs
```

The associated Javascript now becomes a little more complex from version presented above:

```javascript
var startUpload = function (fileUploadField, form, xProgressField, progressBar, notificationField) {
	var filename = fileUploadField.val();

	if (filename && filename.length) {
		var xProgressId = xProgressField.val();
		var formActionUrl = form.attr("action");
		/* add X-Progress-ID parameter if its not already there otherwise replace it */
		if (formActionUrl.indexOf ("X-Progress-ID") == -1) {
			formActionUrl += "&X-Progress-ID=" + xProgressId;
		} else {
			formActionUrl = formActionUrl.replace(/^(.*X-Progress-ID=)(.*)(&.*)?$/, "$1" +xProgressId + "$3");
		}
		form.attr("action", formActionUrl);
		form.submit();

		fileUploadField.val("");
		progressBar.progressbar({value:0});
		progressBar.css("display", "block");
		var intervalId = window.setInterval(function(){
			updateBar(progressBar, xProgressId, notificationField, intervalId)
			}, 1000);
	}

	var updateBar = function(progressBar, xProgressId, notificationField, intervalId) {
		$.ajax({
			url: "/progress",
			beforeSend: function (xhr) {
				xhr.setRequestHeader("X-Progress-ID", xProgressId);
			},
			success: function (data, textStatus, xhr) {
				var upload = eval(data);

				if (upload.state == "done" || upload.state == "uploading") {
					var percentageComplete = Math.floor(upload.received * 100 / upload.size);
					progressBar.progressbar({ value: percentageComplete });
					if (upload.received != upload.size) {
						setUploadStatus("Uploading: " + percentageComplete + "%");
					} else {
						setUploadStatus("Uploaded: processing");
					}
				}
				if (upload.state == "starting") {
					setUploadStatus("Starting upload");
				}
		        	if (upload.state == "done") {
					clearUploadProgress();
		        	}
			},
			error: function(xhr, textError) {
				setUploadStatus("Error: " + textError);
				window.clearTimeout (intervalId);
			}
		});

		var clearUploadProgress = function() {
			window.clearTimeout (intervalId);
			progressBar.css ("display", "none");
			setUploadStatus ("");
		}

		var setUploadStatus = function(statusText) {
			notificationField.html ("<div class=''status''>" + statusText + "</div>");
		}
	}
}
```

The script polls `/progress` once a second, using a low level ajax call which allows the `X-Progress-ID` parameter to be set:

```javascript
beforeSend: function (xhr) {
	xhr.setRequestHeader("X-Progress-ID", xProgressId);
}
```

The `success` callback interprets the response from `/progress` and updates the progress bar and the text status.

## Understanding how the progress bar receives updates:
Form submission creates an http-post which includes the `X-Progress-ID` parameter:

![](/images/blog/fileupload/post.png)

we then poll `/progress` once a second passing the `X-Progress-ID` parameter:

![](/images/blog/fileupload/get-progress.png)

which results in a response of the form:

![](/images/blog/fileupload/get-progress-response.png)

The response is evaluated:

```
var upload = eval(data);
```

and can be used to calculate the percentage complete:

```
var percentageComplete = Math.floor(upload.received * 100 / upload.size);
```

## Download the code
The code described above is contained in `NAFileUploadStep3` and can be downloaded from the repository http://www.squeaksource.com/fileupload

## Next Step
[Step 4]({% post_url 2011-07-01-Step-4-File-upload-as-a-pluggable-component %}): File upload as a pluggable component.
