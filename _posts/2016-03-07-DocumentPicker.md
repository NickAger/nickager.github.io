---
layout: post
title: "NADocumentPicker - Swift document picker UI"
tags: [Swift, iOS, Cocoapods, UIDocumentMenuDelegate, UIDocumentPickerDelegate, iCloud]
date: 2016-03-07
excerpt_separator: <!--more-->
---
I've released a Cocoapod that encapsulates UIKit document picker UI; allowing the user to select iCloud documents (and Google Drive, One Drive, etc), with a simple [`Future` ](https://github.com/Thomvis/BrightFutures) based API.

![](/images/blog/DocumentPicker/filepicker-combined.jpg)

<!--more-->
The component implements both [UIDocumentMenuDelegate](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIDocumentMenuDelegate_Protocol/index.html) and [UIDocumentPickerDelegate](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIDocumentPickerDelegate/) and provides a simple [`Future` ](https://github.com/Thomvis/BrightFutures#examples) based API.

## Usage

`NADocumentPicker.show(..)` returns a [`Future` ](https://github.com/Thomvis/BrightFutures#examples). Hooking into `onSuccess` provides the URL of the file choosen by the user:

```swift
@IBAction func pickerButtonPressed(sender: UIButton) {
    let urlPickedfuture = NADocumentPicker.show(from: sender, parentViewController: self)

    urlPickedfuture.onSuccess { url in
        print("URL: \(url)")
    }
}
```

## Implementation details.

One of the challenges of keeping a simple API, was how to ensure that the `NADocumentPicker` object remains in memory until the [`Future` ](https://github.com/Thomvis/BrightFutures#examples) completes. The trick I used was to add a reference count to the object that is only freed when `onComplete` fires:

```swift
public class NADocumentPicker : NSObject {
    private var keepInMemory: NADocumentPicker?
    .
    .
    private func keepOurselvesInMemory() {
        keepInMemory = self
    }

    private func freeOurselvesFromMemory() {
        keepInMemory = nil
    }

    private func keepInMemoryUntilComplete() {
        keepOurselvesInMemory()
        self.promise.future.onComplete { [unowned self] _ in
            self.freeOurselvesFromMemory()
        }
    }

    private init(...) {
      .
      .
      keepInMemoryUntilComplete()
    }
}
```

If the property `keepInMemory` is non-nil the object will not be freed. The object sets `keepInMemory` to `nil` within an `onComplete` block. This completion block will be called for success or failure. Success when the user picked a file and failure if the user dismisses the UI without choosing a file.

## Installation

`NADocumentPicker` is available as a [Cocoapod](https://cocoapods.org). To incorporate the document picker into your project add the following to your `Podfile` eg:

```ruby
target '<YourProject>' do
    pod 'NADocumentPicker'
    .
    .
end
```

You can try-out `NADocumentPicker` demo project by using the cocoapod `try` option as:

```
$ pod try NADocumentPicker
```

### See Also

* [NADocumentPicker.swift](https://github.com/NickAger/NADocumentPicker/blob/master/NADocumentPicker/NADocumentPicker.swift#L25) on GitHub.
* [NADocumentPicker project](https://github.com/NickAger/NADocumentPicker) on GitHub.
* [Searching for a Swift Future library]({% post_url 2016-01-20-searching-for-a-future-library %})
* [Profit from Futures]({% post_url 2016-02-10-profit-from-futures %})
* [https://github.com/Thomvis/BrightFutures](https://github.com/Thomvis/BrightFutures)
