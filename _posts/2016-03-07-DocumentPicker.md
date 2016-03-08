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
The component implements both [UIDocumentMenuDelegate](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIDocumentMenuDelegate_Protocol/index.html) and [UIDocumentPickerDelegate](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIDocumentPickerDelegate/) and provides a simple [Future](https://github.com/Thomvis/BrightFutures#examples) based API.

## Usage

```swift
@IBAction func pickerButtonPressed(sender: UIButton) {
    let urlPickedfuture = NADocumentPicker.show(from: sender, parentViewController: self)

    urlPickedfuture.onSuccess { url in
        print("URL: \(url)")
    }
}
```

`NADocumentPicker` returns a [Future](https://github.com/Thomvis/BrightFutures#examples). Hooking into `onSuccess` provides the URL of the file choosen by the user.

## Installation

It is available as a [Cocoapod](https://cocoapods.org). To incorporate the document picker into your project add the following to your `Podfile` eg:

```ruby
target '<YourProject>' do
    pod 'NADocumentPicker', :git => 'git@github.com:NickAger/NADocumentPicker.git'
    .
    .
end
```

### See Also

* [https://github.com/NickAger/NADocumentPicker](https://github.com/NickAger/NADocumentPicker)
* [Searching for a Swift Future library]({% post_url 2016-01-20-searching-for-a-future-library %})
* [Profit from Futures]({% post_url 2016-02-10-profit-from-futures %})
* [https://github.com/Thomvis/BrightFutures](https://github.com/Thomvis/BrightFutures)
