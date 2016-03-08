---
layout: post
title: "NADocumentPicker - Swift document picker UI"
tags: [Swift, iOS, Cocoapods, UIDocumentMenuDelegate, UIDocumentPickerDelegate]
date: 2016-03-07
excerpt_separator: <!--more-->
---
I've released a Cocoapod that encapsulates UIKit document picker UI on [GitHub](https://github.com/NickAger/NADocumentPicker.git).

![](/images/blog/DocumentPicker/filepicker-combined.jpg)

<!--more-->
The component implements both [UIDocumentMenuDelegate](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIDocumentMenuDelegate_Protocol/index.html) and [UIDocumentPickerDelegate](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIDocumentPickerDelegate/)

It is available as a [Cocoapod](https://cocoapods.org). To incorporate the document picker into your project add the following to your `Podfile` eg:

```ruby
target '<YourProject>' do
    pod 'NADocumentPicker', :git => 'git@github.com:NickAger/NADocumentPicker.git'
    .
    .
end
```

See: [https://github.com/NickAger/NADocumentPicker](https://github.com/NickAger/NADocumentPicker)
