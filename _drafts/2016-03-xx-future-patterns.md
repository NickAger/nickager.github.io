---
layout: post
title: "Future Patterns"
date: 2016-03-xx
excerpt_separator: <!--more-->
---
In the [Profit from Futures]({% post_url 2016-02-10-profit-from-futures %}) post I stated the following:

> Futures allow asynchronous code to compose in ways that are unimaginable with callback blocks

Unfortunately I gave little to justification for this bold statement, which I aim to correct with this post.
<!--more-->
Here are some common patterns I've used with [Futures](https://github.com/Thomvis/BrightFutures)

* Activity indicator while waiting for the Future to complete.
* Returning JSON into users
* Lazy network initialisation
* Chaining Futures (eg 1/5, 2/5, 3/5, 4/5, 5/5) - if one fails they will all fail.
* Delay Futures
* Wait for all Futures to complete
* Network up as a guard future. - sometimes you wait to fast-fail.
* On a failed future, return another future.

Talk about threading models. see https://github.com/Thomvis/BrightFutures#default-threading-model for example:

```swift
static func authenticateUser() -> Future<Bool, AnyError> {
    let future = touchIDAuthenticate().recoverWith(context: Queue.main.context) { _ in
        return passwordAuthenticate()
    }
    return future
```



pyramid of doom
http://raynos.github.io/presentation/shower/controlflow.htm?full#OpeningSlide

Callbacks considered a smell
http://adamghill.com/callbacks-considered-a-smell/


https://fsharpforfunandprofit.com/posts/computation-expressions-continuations/

Of course we could rewrite the whole lot in haskell as:


See:

[Future Proofing](https://github.com/Thomvis/FutureProofing) - extensions to CocoaTouch that provide a Future based interface to asynchronous API's

See also:
http://commandshift.co.uk/blog/2014/03/19/using-dispatch-groups-to-wait-for-multiple-web-services/
