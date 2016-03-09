---
layout: post
title: "Productivity in Swift vs Objective-C"
date: 2015-11-27
tags: [Swift, iOS, Objective-C, static]
excerpt_separator: <!--more-->
---
Coding in Swift feels slower than Objective-C. I'm sure that's partly due to not yet having the same level of mastery of Swift, that I felt I had with Objective-C. However I came across this quote, which reflects my experience:

> Dynamically typed languages give fast positive feedback, but slow negative feedback, whereas statically typed languages do the reverse.

The quote was based on a comparison of Javascript and Scala, but I think a similar (although less extreme) dynamic vs static chasm divides Objective-C and Swift.<!--more--> In Objective-C I can build an application very rapidly, but in doing so I won't have considered many error conditions. Whereas Swift's more advanced type system forces you to handle failure cases and ensures your types match.

A common error I saw causing crashes in released apps - mine and others (hello Xcode) - was inserting a `nil` into an `NSArray`. Swift's type-system should entirely eliminate this source of failure.


### Xcode lends a hand
The other thing I've noticed is that Xcode appears to be providing more helpful completions with Swift than Objective-C. With Swift Xcode feels like a welcomed partner as I write my Swift code; helping me with function signatures and providing closure bodies. I didn't feel the same way about Xcode and Objective-C.

That said Apple still has a way to go on with Xcode and Swift:

![](/images/blog/swift-vs-objective-c/cantrefactorswiftcode.png)

![](/images/blog/swift-vs-objective-c/xcode-editor-error.png)
