---
title: "Step 1: Using Nginx upload module to stream file uploads directly to disk"
tags: "Nginx upload Seaside"
date: 2011-07-02
---
The default download of Nginx doesn't include the [file upload module](http://www.grid.net.ru/nginx/upload.en.html). A previous  [post](/blog/compiling-nginx-to-add-extra-modules) - [Recompiling Nginx to add extra modules](/blog/compiling-nginx-to-add-extra-modules) describes how to recompile Nginx to add the [file upload module](http://www.grid.net.ru/nginx/upload.en.html) module used in this post and also the [upload progress module](http://wiki.nginx.org/NginxHttpUploadProgressModule) used in [step 3](/blog/File-upload-using-Nginx-and-Seaside---step-3) 

##Nginx configuration changes
In a previous [post](http://www.nickager.com/blog/Installing-Gemstone-on-an-Amazon-EC2-Linux-instance/#configuringNginx) I explain how I configure Nginx for Seaside within Gemstone, see [here](http://www.nickager.com/blog/Installing-Gemstone-on-an-Amazon-EC2-Linux-instance/#configuringNginx). To your Nginx configuration add the following:

```
location ~ fileupload {
     # Pass altered request body to this location
     upload_pass   @seaside;

     # if there's no upload file in this request, nginx generates a 405 - we use this
     # to pass the request onto the 'normal' seaside processing
     # The way this is achieved in the other location directives is through a "try_files" method
     # however using "try_files" results in the other directives never being processed
     error_page 405 415 = @seaside;

     # Store files to this directory
     # The directory is hashed, subdirectories 0 1 2 3 4 5 6 7 8 9 should exist
     # cd /var/nginx/temp
     # make directories 0, 1, 2, 3, 4 ... 9
     # for (( i = 0; i < 10; i++ )) ; do
     #   mkdir $i
     # done
     upload_store /var/nginx/temp 1;

     # Set the file attributes for uploaded files
     upload_store_access user:rw group:rw all:rw;

     # Set specified fields in request body
     upload_set_form_field $upload_field_name.name "$upload_file_name";
     upload_set_form_field $upload_field_name.content_type "$upload_content_type";
     upload_set_form_field $upload_field_name.path "$upload_tmp_path";

     # Inform backend about hash and size of a file
     # upload_aggregate_form_field "$upload_field_name.md5" "$upload_file_md5";
     upload_aggregate_form_field "$upload_field_name.size" "$upload_file_size";

     # seaside automatically assigns sequential integers to fields with callbacks
     # we want to pass those fields to the backend 
     upload_pass_form_field "^\d+$";

     # we don't want files hanging around if the server failed to process them.
     upload_cleanup 500-505;
 }
```

The above Nginx location directive matches any URLs containing the `fileupload` path. Switching now to Seaside code, we ensure that the file upload component creates a URL containing `fileupload`, by overriding `updateUrl:`

```Smalltalk
updateUrl: aUrl
	super updateUrl: aUrl.
	
	"Nginx configuration contains a specific fileupload handler for a url containing 'fileupload'"
	aUrl addToPath: 'fileupload'
```

Nginx's upload file module rewrites the post request, removing the file-upload field name and adding a new set of fields. The names of these fields depend on the configuration, in our case the relevant lines are:

```
# Set specified fields in request body
upload_set_form_field $upload_field_name.name "$upload_file_name";
upload_set_form_field $upload_field_name.content_type "$upload_content_type";
upload_set_form_field $upload_field_name.path "$upload_tmp_path";
upload_aggregate_form_field "$upload_field_name.size" "$upload_file_size";
```

For this configuration the original file-upload field name (`$upload_field_name`) is used as a prefix for four new fields:
* `name` - the original filename.
* `content-type` - the mime-type.
* `path` - the temporary upload path.
* `size` - the file size.

By default Seaside assigns sequential numbers to form fields. Here's an example where Seaside had assigned "2" as the fileUpload field name and I'd examined the incoming request, by inspecting `self requestContext request postFields`

```
# postFields keys: `#('2.name', '2.content_type', '2.path', '2.size')`
# postFields values: `#('home-05.jpg', 'image/jpeg', '/var/nginx/temp/6/0000000056', '1127528')`


As the name assigned to the fileUpload field doesn't appear as a key in the `postFields` the callback handler associated with the fileUpload is never called. Instead we add a callback to a hidden field and within that callback  we extract the name of the fileUpload field (in our example "2") and prepend that name to the four fields Nginx adds to the postFields:

```Smalltalk
renderUploadFormOn: html
	html form multipart; class: 'uploadForm'; with: [
		| fileUploadField |
		
		"The Nginx handler stores the file uploaded in a specified location and adds POST parameters
		for the filename, the size, the file type etc. 
		These parameters are then interpreted by the server form handling code.
		Note: the file uploaded parameter (the file contents) is removed from the form variables."
		
		fileUploadField := html fileUpload
			callback: [ :file | 
				"should never get here as Nginx's upload file model removes the
				uploaded parameter from the form variables in the post request, so
				Seaside never fires the callback"
				self error: 'Check your Nginx configuration' ].
			
		html hiddenInput
			value: 'hidden';
			callback: [:val | | uploadFieldName |
				"what name did Seaside assign to the file upload form field?"
				uploadFieldName := fileUploadField attributeAt: 'name'.
				self storeUploadedFile: uploadFieldName ].
					
        	html submitButton: 'Upload File' ]
```

The `#storeUploadedFile:` method extracts the fields manually from `self requestContext request postFields`:

```Smalltalk
storeUploadedFile: uploadFieldName
 	| postFields fileName uploadFilePath urlFilePath url mimeType fileSize filePath |

	postFields := self requestContext request postFields.

	"has nginx file upload module inserted it's post fields in the request?"
	fileName := (postFields at: (uploadFieldName, '.name') ifAbsent: [ ^ self ]).
	uploadFilePath := postFields at: (uploadFieldName , '.path').
	fileSize := (postFields at: (uploadFieldName , '.size')) asInteger.
	mimeType := WAMimeType fromString: (postFields at: (uploadFieldName , '.content_type')).

	filePath := self uploadDestinationDirectory, fileName.
	self moveFrom: uploadFilePath toDirectory: self uploadDestinationDirectory name: fileName. 
	
	url := self uploadFilesUrlRoot, fileName.		

	"store a reference to the uploaded file in the session. The session deletes uploaded file when it expires"
	self session addUploadedFile: (NAFile filesize: fileSize fileName: fileName filePath: filePath  contentType: mimeType url: url)
```

Nginx streams the uploaded file to a temporary directory - in our configuration in a directory under `/var/nginx/temp/`. Note subdirectories 0 1 2 3 4 5 6 7 8 9 should exist under this temporary directory:

```
sudo mkdir -p /var/nginx/temp
sudo chown -R seasideuser:seasideuser /var/nginx/
sudo chown seasideuser:seasideuser /var/www/
cd /var/nginx/temp
# make directories 0, 1, 2, 3, 4 ... 9
for (( i = 0; i < 10; i++ )) ; do
  mkdir $i
done

cd /var/log
sudo chown -R seasideuser:seasideuser nginx
cd /var/lib
sudo chown -R seasideuser:seasideuser nginx
```

We use the OS move file command, in this case `mv` to move the file to a directory that can then be served by Nginx directly:

```Smalltalk
moveFrom: fromString toDirectory: uploadDestinationDirectory name: filename
	| shellMoveFileCommand |
	
	"GRPlatform current ensureExistenceOfFolder: uploadDestinationDirectory."
	
	"use the OS move ('mv') command to move the uploaded file from where the webserver 
	saves the file to the destination directory; ensure we don't load the file into memory"
	shellMoveFileCommand := String streamContents: [:stream |
		stream 
			nextPutAll: 'mv ';
			nextPutAll: fromString;
			nextPutAll: ' ''';
			nextPutAll: uploadDestinationDirectory;
			nextPutAll: filename;
			nextPutAll: '''' ].
		
	SpEnvironment runShellCommandString: shellMoveFileCommand.
```

Currently uploading a file, causes a whole page refresh. Also there is no indication of upload progress. In the subsequent steps we resolve these issues:

## Download the code
The code described above is contained in `NAFileUploadStep1` and can be downloaded from the repository [](http://www.squeaksource.com/NginxFileUpload).

## Next Steps
* [Step 2](/blog/File-upload-using-Nginx-and-Seaside---step-2): Using a hidden iframe to enable ajax-like file uploads.
* [Step 3](/blog/File-upload-using-Nginx-and-Seaside---step-3): Using Nginx upload progress module to report upload progress to the user.
* [Step 4](/blog/Step-4-File-upload-as-a-plugable-component): File upload as a plugable component.
