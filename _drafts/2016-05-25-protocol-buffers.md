---
layout: post
title: "Protocol buffers"
date: 2016-02-12
excerpt_separator: <!--more-->
---
After much inactivity Google recently released version 3 Jul 2016 and have been releasing new versions since then.

Apple appear to have adopted protobuf with an open-source repository. https://github.com/apple/swift-protobuf/ . In an embassment of riches, Objective-C is now a first-class language supported by protocol buf so can be used with a swift bridging header.

Also I've seen big advantages in using strongly typed languages and so believe I should see similar advantages in using a typed message format.

I question, how to serialise discrimated unions/enums with associated values/alebraic types:
From: https://news.ycombinator.com/item?id=996958

> Heterogeneous collections, discriminated unions, and GADTs can be implemented easily in either thrift or protobuf by leveraging inclusion of custom type-tagged messages/data.
> However, while the encodings are absolutely sufficient to represent these data structures -- if you so choose -- my experience dictates that keeping serialized messages typed and as simple as possible is advantageous from the perspective of long-term maintenance and interoperability.

 https://chromium.googlesource.com/chromium/src/third_party/+/master/protobuf/docs/swift/DesignDoc.md

https://www.google.com/search?client=safari&rls=en&q=protocol+buffers+algebraic+types&ie=UTF-8&oe=UTF-8


* [Protocol buffers](https://developers.google.com/protocol-buffers/) [github](https://github.com/google/protobuf)
* [Swift support for protocol buffers (Apple)](https://github.com/apple/swift-protobuf/) or [3rd party](https://github.com/alexeyxo/protobuf-swift)
* [Flatbuffers](https://google.github.io/flatbuffers/)
* [What's the difference between the Protocol Buffers and the Flatbuffers?](http://stackoverflow.com/questions/25356551/whats-the-difference-between-the-protocol-buffers-and-the-flatbuffers)
* [Thift](https://thrift.apache.org)
* [Thrift 2905 & - Modern Objective-C & Swift Support #539](https://github.com/apache/thrift/pull/539)
