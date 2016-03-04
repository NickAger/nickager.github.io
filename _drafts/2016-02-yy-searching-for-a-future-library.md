---
layout: post
title: "Searching for a Swift Future library"
date: 2016-01-20
excerpt_separator: <!--more-->
---
Futures and [Promises](http://promisesaplus.com) are a fantastic abstraction for asynchronous operations which I'll write about in a future post. In Objective-C I used a version of [SHXPromise](https://github.com/MSNexploder/SHXPromise) which worked well for us.

Searching for an equivalent in Swift, I narrowed my choice to:

* [Promise Kit](http://promisekit.org)
* [Future Kit](https://github.com/FutureKit/FutureKit)
* [Bright Futures](https://github.com/Thomvis/BrightFutures)






In objective-C I used SHXPromise


Options:


ReactiveCocoa

I liked the functional composition built into Bright Futures


Evaluating 3rd party components
When evaluating a 3rd party library consider the following:

• How many contributors does the code/library/component have?
• Does the library/component contain tests?
• How recent was the last update?
• Is there documentation associated with the component?
• Does the component come with source?
• How is the component licensed: MIT, BSD, Apache = OK; GPL = problems.
• How quickly did fixes go in when a new iOS version is released eg iOS6->iOS6.1->iOS7->iOS7.1->iOS8.0->iOS8.1->... and XCode 4->4.5->5.0->6.0->7.0?
• Does the project make use of recent iOS technologies where appropriate.
• Does the project maintain its own cocoapods spec?
• Does the project have questions on StackOverflow? Are those questions answered?

Just add the above to a table of the above components
