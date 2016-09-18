---
title: "Uncle Bob considered Optional"
date: 2018-08-08
tags: [grump old-git, Uncle Bob, Haskell, Swift, functional programming, null]
layout: post
---

"You live and learn - when you get to my age you've done enough learning and you just want to do some living"

OH: “Uncle Bob is the Donald Trump of the software industry.”

[The Churn](http://blog.cleancoder.com/uncle-bob/2016/07/27/TheChurn.html)

Or it could have read - "the older we get the more we become naturally resistant to new technologies which can help us"

OR - "grumpy old man can't keep up with the kids"

I guess the article has only got so much attentipn as a class of iOs developers are questioning
the value of moving to Swift; whether there is sufficient gain for the pain.

Surprised that Uncle Bob shared much of my programming experience, C, C++,  Smalltalk, Java. However he seems to have stopped on the journey I've been on more strongly typed languages.
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


Gannt chart showing strict statically typed languages, what can be expressed in those languages.

Richard on tests + types + immutability

Then again he has a point - I'm amazed that PHP survives so long - Workpress, Kieren - doesn't seem to have given me better abilities - I'm confident it will (multicore future etc)

See also:

* [On Dynamism](https://www.noodlesoft.com/blog/2016/05/23/on-dynamism/)

Null
http://guide.elm-lang.org/error_handling/
Any time you think you have a String you just might have a null instead. Should you check? Did the person giving you the value check? Maybe it will be fine? Maybe it will crash your servers? I guess we will find out later!

The inventor, Tony Hoare, has this to say about it:

I call it my billion-dollar mistake. It was the invention of the null reference in 1965. At that time, I was designing the first comprehensive type system for references in an object oriented language (ALGOL W). My goal was to ensure that all use of references should be absolutely safe, with checking performed automatically by the compiler. But I couldn't resist the temptation to put in a null reference, simply because it was so easy to implement. This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused a billion dollars of pain and damage in the last forty years.

As we will see soon, the point of Maybe is to avoid this problem in a pleasant way.
