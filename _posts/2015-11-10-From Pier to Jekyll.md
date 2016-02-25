---
layout: post
title: "Changing blogging platform"
date: 2015-11-10
---
My original blog used [Pier](http://www.piercms.com) which was built on the [Seaside web framework](http://seaside.st). I become very familiar with [Pier](http://www.piercms.com) while working on getitmade.com. [Pier](http://www.piercms.com) merged static and dynamic content, easily allowing new components to be embedded in static content managed through its CMS interface. I even invested considerable time in building [Pier Admin]((https://vimeo.com/32749535)), releasing a WYSIWYG editor for Pier as well as many other improved admin tools. My series of posts on building a [file upload component]({% post_url 2011-07-01-File-upload-using-Nginx-and-Seaside %}), embedded the described components as live examples directly into the content, in a way I've not seen achieved elsewhere. Pier also allowed code to be pulled directly into the content with markup such as:

```
+value:source | class=NAFileUploadExample | method=onUploadProgressCallback+
```

which resulted in the following code appearing in the content with the code highlighting being generated directly from the AST:

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

I became excited by the idea of extending Pier to support online technical book publication whose code examples you could interact with directly. It felt like future. (See [School of Haskell](http://www.schoolofhaskell.com) for a recent implementation of the same idea).  

However ... when you are the person who uses and develops the software more than others you become the defacto maintainer. When the community is small, and you are the 90% contributor, you end up having to build a lot of the [infrastructure yourself]({% post_url 2011-01-02-Create-a-reusable-Amazon-machine-instance %}). This might be sustainable if the technology is also providing an income, but if it ultimately is just used for an occasional blog entry, its hard to justify spending any time on maintenance.

So I started looking for something that is simple to use, easy to host and well supported. In short a blogging platform I don't have to support.

Enter [Jekyll](http://jekyllrb.com). It generates static content that can be hosted anywhere, but even better, [Github](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/) provides free hosting and automatic generation of [Jekyll](http://jekyllrb.com) based content.

[Jekyll](http://jekyllrb.com) has a completely different philosophy to site generation from [Pier](http://www.piercms.com), we'll see how I get on.
