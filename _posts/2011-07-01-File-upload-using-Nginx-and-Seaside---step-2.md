---
title: "Step 2:  Using a hidden iframe to enable ajax-like file upload"
date: 2011-07-01 10:03:00 +0000
tags: "Nginx, upload"
layout: post
---

In this step we upload the file in the background in an AJAX-like style. Note we are not using the AJAX `XMLHttpRequest` as at the time of writing it was not possible to use an `XMLHttpRequest` for multipart form uploads. The work-around is to use a hidden iframe to submit the form. The main render method becomes:

```smalltalk
renderContentOn: html
	html div
		class: 'fileuploadExample';
		with: [
			self renderUploadFormOn: html.
			self renderHiddenIFrameOn: html.

			self renderUploadedFilesOn: html.
			self renderFileUploadedCallbackJSOn: html ]
```

the iframe is rendered off-screen (`position:absolute;top:-1000px;left:-1000px`)

```smalltalk
renderHiddenIFrameOn: html
	html iframe
		name: 'hiddenImageIFrameUploader';
		id: #hiddenImageIFrameUploader;
		style: 'position:absolute;top:-1000px;left:-1000px';
		attributeAt: 'onload' put: 'fileUploadedCallback()'
```

the form declaration is changed to set the form's target to the iframe:

```smalltalk
html form
    multipart;
    attributeAt: 'target' put: 'hiddenImageIFrameUploader';
    class: 'uploadForm'; with: [ "form fields go here..." ]
```

Now when the form's submit button is pressed the response is rendered within the iframe.

The response handling in the `hiddenInput` completes with a call to `renderIFrameResponse` as:
```smalltalk
html hiddenInput
    callback: [:val | | uploadFieldName |
        "what name did Seaside assign to the file upload form field?"
        uploadFieldName := fileUploadField attributeAt: 'name'.
        self storeUploadedFile: uploadFieldName.
        self renderIFrameResponse ].
```

with `renderIFrameResponse` rendering the uploaded files:

```smalltalk
renderIFrameResponse
	"Respond directly with the uploaded files"
	self requestContext respond:
		[ :response |
		response
			contentType: WAMimeType textHtml;
			nextPutAll: (WARenderCanvas builder
				fullDocument: true;
				scriptGeneratorClass: JQScriptGenerator; "removes the onload from body"				
				render: [:html | self renderUploadedFilesOn: html  ] )]
```

The iframe declaration above contains `attributeAt: 'onload' put: 'fileUploadedCallback()'`. When the response is loaded by the iframe, the iframe's `onload` will trigger a call to the javascript method `fileUploadedCallback()`, which is defined by:

```smalltalk
renderFileUploadedCallbackJSOn: html
	html script:
'var fileUploadedCallback = function() {
	$("#uploadedFilesContainer").replaceWith($("#hiddenImageIFrameUploader").contents().find("#uploadedFilesContainer"))
	}'
```

This script copies a div (`#uploadedFilesContainer`) inside the just updated iframe to the same named div, rendered just below the upload form, displaying the newly uploaded file and any previously uploaded files.

## Download the code
The code described above is contained in `NAFileUploadStep2` and can be downloaded from the repository http://www.squeaksource.com/NginxFileUpload.

## Next Steps
* [Step 3](File-upload-using-Nginx-and-Seaside---step-3): Using Nginx upload progress module to report upload progress to the user.
* [Step 4](Step-4-File-upload-as-a-plugable-component): File upload as a plugable component.
