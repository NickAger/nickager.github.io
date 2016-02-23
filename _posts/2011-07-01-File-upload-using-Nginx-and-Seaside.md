---
title: "File upload using Nginx and Seaside"
tags: [Nginx, upload, progress]
date: 2011-07-01 08:03:00 +0000
layout: post
---
The [Seaside book](http://book.seaside.com) explains how to write a simple file [upload component](http://book.seaside.st/book/fundamentals/forms/fileupload):

```smalltalk
renderContentOn: html
    html form multipart; with: [
        html fileUpload
           callback: [ :file | "self receiveFile: file" ].
        html submitButton: 'Send File' ]
```

The above code is a good starting point and in many ways showcases [Seaside's](http://seaside.st) elegant approach to [callbacks](http://book.seaside.st/book/fundamentals/anchors/callbacks). However for a production site, a major drawback is that the
 file is loaded into a `ByteArray` within the image. Even if the file is immediately saved, large files will temporarily consume significant memory. A better solution is to avoid loading the file into your running image altogether and let the front-end server take the strain. In this case I'm using [Nginx](http://wiki.nginx.org/), which can stream the bytes directly to a file as it is uploaded, avoiding large spikes in consumed memory. An additional benefit is that [Nginx](http://wiki.nginx.org/) allows us to provide the user with customised upload progress feedback.

The associated posts describes how to integrate [Seaside](http://seaside.st) and [Nginx](http://wiki.nginx.org/) to create a production-quality file upload solution.

The key features are:

* The uploaded file is streamed directly to disk by Nginx.
* The upload occurs in the background, in an AJAX-like style.
* You should see an upload progress bar update - depending on your uplink speed and the size of the file.
* You can upload multiple files.

There a quite a few pieces which co-operate to enable this functionality. I've described the functionality over four posts:

* [Step 1](File-upload-using-Nginx-and-Seaside-step-1): Using Nginx upload module to stream file uploads directly to disk.
* [Step 2](File-upload-using-Nginx-and-Seaside-step-2): Using a hidden iframe to enable ajax-like file uploads.
* [Step 3](File-upload-using-Nginx-and-Seaside-step-3): Using Nginx upload progress module to report upload progress to the user.
* [Step 4](Step-4-File-upload-as-a-plugable-component): File upload as a plugable component.

The first three steps describe how the file upload component works. It follows a development journey similar to the one I've undertaken in developing the component. Each step adds an additional feature (and complexity). The fourth step describes how to configure a reusable upload component, which I've extracted from the component presented in [step 3](File-upload-using-Nginx-and-Seaside-step-3). If you only want to use the component, skip straight to [step 4](Step-4-File-upload-as-a-plugable-component).

The two Nginx components which enable this functionality are:

* [Nginx Upload progress module](http://wiki.nginx.org/HttpUploadProgressModule)
* [Nginx Upload module](http://www.grid.net.ru/nginx/upload.en.html)

The default download of Nginx doesn't include these modules, a previous  [post](compiling-nginx-for-extra-modules) - [Compiling Nginx to add extra modules](compiling-nginx-for-extra-modules) describes how to recompile Nginx to include these modules.

## Download the code
The code described in the following sections can be downloaded from the repository [](http://www.squeaksource.com/NginxFileUpload)

## Alternatives
People have pointed out [Uploadify](http://www.uploadify.com/documentation/) as an alternative. I can't see how [Uploadify](http://www.uploadify.com/documentation/) would avoid loading the file directly into memory. It also requires Flash  - that said the UI looks very slick and would be worth using for some design clues.

## Credits
Esteban Lorenzano helped create the initial version of this component.
