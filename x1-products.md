---
layout: product
title: Products
permalink: /products/
---

### DocumentPicker

Cocoapod that encapsulates UIKit document picker UI; allowing the user to select iCloud documents (or documents from other providers), with a simple [`Future` ](https://github.com/Thomvis/BrightFutures) based API.

![](/images/blog/DocumentPicker/filepicker-combined.jpg)

See blog post: [Swift document picker UI]({% post_url 2016-03-07-DocumentPicker %})

---

### iDiff View
<table>
<tr>
<td width="145px"><a href="https://itunes.apple.com/us/app/idiff-view/id1084386974?mt=8"><img src="/images/blog/iDiffView/iDiffViewIcon.svg" style="width:100px;margin-left:20px;"/></a></td>
<td rowspan="2">iDiff View highlights the difference between two versions of a text file showing which characters/words and lines have changed, highlighting additions and deletions. Files are chosen from document providers, such as iCloud Drive, Google Drive, OneDrive etc.</td>
</tr>
<tr><td><a href="https://itunes.apple.com/us/app/idiff-view/id1084386974?mt=8"><img src="/images/apple-marketing-images/App_Store_Badge_US-UK_135x40.svg" style="height:40px;width:135px;margin:5px;"/></a></td>
</tr>
</table>

---

### JQuery Mobile for Seaside

Seaside integration with JQuery-Mobile see [http://jquerymobile.seasidehosting.st](http://jquerymobile.seasidehosting.st)

---

### Pier admin
Demonstration of the Pier Administration interface see [overview video](https://vimeo.com/32749535), showing the WYSIWYG editor, the tree view and other administrative features.

---

### Seafox
A [Firefox](https://www.mozilla.org/en-US/firefox/new/) plug-in and on-line html converter which translates Html into Seaside canvas methods. For example:

```
   <a href='http://www.seaside.st'>Seaside site</a>
```
is translated into:

```smalltalk
html anchor url: 'http://www.seaside.st' with: 'Seaside site'.
```
See [Seafox](http://seafox.seasidehosting.st)

---

### Seaside web-framework
I was one of the co-maintainers of the [Seaside web-framework](seaside.st) and managed a number of releases.

---

# Talks & screencasts

* [Deploy your Seaside application for free with an EC2 micro instance and Gemstone](https://vimeo.com/18375790). A screen cast showing how to use a pre-configured AMI (Amazon Machine Image) to deploy your Seaside applications using EC2 and Gemstone.
* [An Introduction to Magritte 3](https://vimeo.com/37032840).  Describing the rational for Magritte 3, how to upgrade a project from Magritte 1 or 2 to Magritte 3. Includes a walk through of the refactoring tool developed to ease migration. The video includes a brief demonstration of form building using a custom form render and the Magritte json and xml-binding add-ons.
* [Pier admin](https://vimeo.com/32749535). A demonstration of the new Pier Administration interface, showing the WYSIWYG editor, the tree view and other administrative features.
* [Flickr Photos with JQueryMobile](https://vimeo.com/31600152). A Tutorial describing how to create a simple JQueryMobile application using the Seaside webframe that browses photos retrieved from flickr that match an entered tag.
