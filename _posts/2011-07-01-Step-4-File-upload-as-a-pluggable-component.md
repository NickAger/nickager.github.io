---
title: "Step 4: File upload as a pluggable component"
date: 2011-07-01 12:03:00 +0000
layout: post
---
In this final post, I've morphed the code I've presented so far into a pluggable upload component: `NAFileUpload`. I've created an example component `NAFileUploadExample` to illustrate how to use `NAFileUpload`. There are six callbacks and one configuration id which should be set:

* `onFileUploaded:` - server-side callback, called when a new file has been uploaded. An `NAFile` is passed into the callback block.
* `onRenderUploadedFiles:` - server-side callback, called after the file has been uploaded, to re-render the uploaded files.
* `uploadedFilesContainerId:` the id of the container showing the uploaded files.
* `onRenderForm:` - a hook to allow you to render your own upload button. In `NAFileUploadExample` we configure the `fileUpload` field to automatically start the upload, once a file is choosen.
* `onBeforeUpload:` - client-side callback, called immediately before the upload starts. In the example we display the progress bar in this callback.
* `onUploadProgress:` - client-side callback, called repeatedly with upload progress. Used to report upload progress to the user.
* `onUploadError:` - client-side callback, called when there is upload error.

There are additional comments on setter methods of in `NAFileUploadConfiguration`

In `NAFileUploadExample` we lazily create and configure the `NAFileUpload` component:

```smalltalk
uploadComponent
	^ uploadComponent ifNil: [
		| progressBar |
		uploadComponent := NAFileUpload new.

		uploadComponent configuration
			onFileUploaded: [ :file | self storeUploadedFile: file ];
			onRenderUploadedFiles: [ :html | self renderUploadedFilesOn: html ] ;
			uploadedFilesContainerId: #uploadedFilesContainerId;
			onRenderForm: [ :html :fileUploadField :fileUploadStartJS |
				fileUploadField onChange: fileUploadStartJS ];
			nginxUrlLocation: 'fileupload'.

		"might be easier to do this in straight javascript; instead I'm using Seaside
		javascript API for illustration"
		progressBar := JQueryClass new with: #progressBarId.
		progressBar cssAt: 'display' put: 'block'.

		uploadComponent configuration
			onBeforeUpload: (progressBar progressbar value: 0) asFunction;
			onUploadError: self onUploadErrorCallback;
			onUploadProgress: self onUploadProgressCallback.

		uploadComponent ]
```

The method `onUploadProgressCallback` is defined in `NAFileUploadExample` to respond to file upload updates and generates the following Javascript:

```javascript
function uploadStatus() {
  if (uploadStatus.state == "done" || uploadStatus.state == "uploading") {
      var percentageComplete = Math.floor(uploadStatus.received * 100 / uploadStatus.size);
      $("#progressBarId").progressbar({ value: percentageComplete });
      if (uploadStatus.received != uploadStatus.size) {
          setUploadStatus("Uploading: " + percentageComplete + "%");
      } else {
          setUploadStatus("Uploaded: processing");
      }
  }
  if (uploadStatus.state == "starting") {
      setUploadStatus("Starting upload");
  }
  if (uploadStatus.state == "done") {
      clearUploadProgress();
  }

  function clearUploadProgress() {
	  $("#progressBarId").css ("display", "none");
	  setUploadStatus ("");
  }

  function setUploadStatus (statusText) {
	  $("#notificationId").html ("<div class=''status''>" + statusText + "</div>");
  }
}

```

## Download the code
The code described above is contained in `NAFileUploadExample` and can be downloaded from the repository http://www.squeaksource.com/fileupload

## Nginx configuration
Here is my complete Nginx configuration for reference:

```
#######################################################################
#
# This is the main Nginx configuration file.  
#
# More information about the configuration options is available on
#   * the English wiki - http://wiki.nginx.org/Main
#   * the Russian documentation - http://sysoev.ru/nginx/
#
#######################################################################

#----------------------------------------------------------------------
# Main Module - directives that cover basic functionality
#
#   http://wiki.nginx.org/NginxHttpMainModule
#
#----------------------------------------------------------------------

user seasideuser seasideuser;
worker_processes  1;

error_log  /var/log/nginx/error.log;
#error_log  /var/log/nginx/error.log  notice;
#error_log  /var/log/nginx/error.log  info;

pid        /var/run/nginx.pid;


#----------------------------------------------------------------------
# Events Module
#
#   http://wiki.nginx.org/NginxHttpEventsModule
#
#----------------------------------------------------------------------

events {
    worker_connections  1024;
}


#----------------------------------------------------------------------
# HTTP Core Module
#
#   http://wiki.nginx.org/NginxHttpCoreModule
#
#----------------------------------------------------------------------

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    keepalive_timeout  65;

    tcp_nodelay        on;

    client_max_body_size 10m;
    upload_max_file_size 10m;
    upload_progress proxied 10m;

    gzip  on;
    gzip_buffers 4 8k;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    upstream seaside {
       server 127.0.0.1:9001;
#       server 127.0.0.1:9002;
#       server 127.0.0.1:9003;
#       fair;
    }

    server {
        listen       80;
        server_name  _;
	root /var/www;

       # first check the file system then try the image.
       location / {
          try_files $uri @seaside;
       }

       # ensure that files are searched for locally and not passed to the
       # Gems if the file isn't found on the disk
       location ~* \.(gif|jpg|jpeg|png|css|html|htm|js)$ {

       }

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
     # for (( i = 0; i < 10; i\+\+ )) ; do
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

     # file upload progress tracking - 30s is the timeout (progress tracking is
     # available 30s after the upload has finished)
     # this must be the last directive in the location block.
     track_uploads proxied 30s;
     }

       # used to report upload progress - defined by the Nginx Upload Progress Module
       # see http://wiki.nginx.org/HttpUploadProgressModule
       location  /progress {
          report_uploads proxied;
       }

       location = /favicon.ico {
           #empty_gif;
           return 204;
       }

       location @seaside {
          include /etc/nginx/fastcgi_params;

          fastcgi_intercept_errors on;
          fastcgi_pass seaside;
       }

      location /nginx_status {
         # copied from http://blog.kovyrin.net/2006/04/29/monitoring-nginx-with-rrdtool/
         stub_status on;
         access_log   off;
         allow 127.0.0.1;
         deny all;
      }

       error_page 404 /errors/404.html;
       error_page 403 /errors/403.html;
       error_page 500 502 503 504 /errors/50x.html;
    }
}
```
