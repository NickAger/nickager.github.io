---
title: "Uncle Bob considered Optional"
date: 2018-08-08
tags: [grump old-git, Uncle Bob, Haskell, Swift, functional programming, null]
layout: post
---

[The Churn](http://blog.cleancoder.com/uncle-bob/2016/07/27/TheChurn.html)

Surprised that Uncle Bob shared much of my programming experience, C, C++,  Smalltalk, Java then we diverge, Objective-C, Haskell, Swift.

Side-panel
Smalltalk the only dynamic language with a decent IDE, no worry that a mistype is going to blow up at runtime.

(editorial - focus on his distain for Optional type in Swift)

Tony Hoare's [Billion Dollar mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare)

I'm sure Apple have analysed the crash reports and see that dereferencing nil is a common error (even with Objective-C nil eating - pulling nil into an NSArray is a common source of trouble in Objective-C)

Java null pointer deferenced - see it on plenty of web-sites

He has a reasonable point that the refactoring in Xcode for Swift is non-existant.

Rather than the tools causing us to stick to one language, Elicpse IntelliJ have shown us that IDEs with the correct abstraction can host multiple languages.

But that said the tooling in many languages is poor compared to Java.

Surely we should be aiming for the LLVM of IDE's rather than sticking to C/C++ before LLVM was a thing, because writing good optimising compilers is hard.

Software development goes in waves, you have to learn new things on occasions then have periods of high-productivity in the new technology before slowing down again to learn a new technology.
