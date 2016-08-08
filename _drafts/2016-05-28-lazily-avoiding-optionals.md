---
title: "Lazily avoiding Optional"
date: 2016-05-28
tags: [Swift, Optional]
layout: post
---
Show the error when a non optional property isn.t defined in init


Here I don't have to define the property as Optional
```
lazy private var baseMessageHandler: BaseMessageHandler = {
    return BaseMessageHandler(messageSender: self.dataSource.messageSender)
}()
```


see https://github.com/apple/swift-evolution/blob/master/proposals/0030-property-behavior-decls.md

> lazy properties as a primitive language feature, since lazy initialization is common and is often necessary to avoid having properties be exposed as Optional. Without this language support, it takes a lot of boilerplate to get the same effect:

```swift
class Foo {
  // lazy var foo = 1738
  private var _foo: Int?
  var foo: Int {
    get {
      if let value = _foo { return value }
      let initialValue = 1738
      _foo = initialValue
      return initialValue
    }
    set {
      _foo = newValue
    }
  }
}
```
