---
layout: post
title: "Profit from Futures"
date: 2016-02-10
tags: [Futures, Promises, async]
excerpt_separator: <!--more-->
---
As most battle-hardened programmers will attest, implementing threaded code that reads or writes to shared mutable state is hard to develop correctly and rapidly degenerates into a maintenance nightmare unless all programmers are equally skilled. Lets quickly why; shared mutable state requires locks and:

* Locks do not compose
* Locks break encapsulation (you need to know a lot!)
* Error recovery is hard
* Its easy to get locks wrong by:
  * Taking too few locks
  * Taking too many locks
  * Taking the wrong locks
  * Taking locks in wrong order

In summary unless handled with extreme caution, threaded code tends to lead to impossible to reproduce bugs - it's non deterministic - you only find out there's a problem when you see the crash reports.<!--more-->

I've found the way to deal with threads in iOS is to try really hard to avoid them.

![](/images/blog/joy-of-futures/synchronous-service-call.png)

Eliminating threads is relatively easy for simple apps, as the networking APIs provide asynchronous callbacks, though behind the scenes the network stack is using threads. I initiate a network request on the main thread and then get called-back on the main-thread with the result.

In more complex apps, I wrap-up threaded background work in a similar manner and provide asynchronous callbacks.

### Futures and promises

[Futures and Promises](https://en.wikipedia.org/wiki/Futures_and_promises) are a great alternative to completion blocks and support typesafe error handling in asynchronous code. Using `Future`s for all asynchronous calls makes explicit the asynchronous nature of an API  and allows the asynchronous code to [compose](https://github.com/Thomvis/BrightFutures#functional-composition) in ways that are unimaginable with callback blocks.

Here's an example of the use of `Future`s taken from [iDiffView](https://itunes.apple.com/us/app/idiff-view/id1084386974?mt=8)

```swift
func readSample() -> Future<(DiffTextDocument, DiffTextDocument), DiffTextDocumentErrors> {
      func readSampleText(assetName: String) -> Future<DiffTextDocument, DiffTextDocumentErrors>  {
        let url = NSBundle.mainBundle().URLForResource(assetName, withExtension: "txt")!
        let document = DiffTextDocument(fileURL: url)
        return document.open()
      }
      return readSampleText("Sample1Left").zip(readSampleText("Sample1Right"))
}
```

The method `readSample()` returns a two element tuple representing the left and right sample documents, wrapped in a `Future`.
The nested function `readSampleText(String)` returns a document wrapped in `Future`. The compositional magic occurs in the line:

```swift
return readSampleText("Sample1Left").zip(readSampleText("Sample1Right"))
```

which uses `zip` to compose the two `Futures` returning a single `Future` wrapping a two element result tuple.

Prior to using `Future`s the above line of code was written using chained closures as:

```swift
readSampleText("Sample1Left") { (document1) in		
    readSampleText("Sample1Right") { (document2) in		
        callback(left: document1, right:document2)		
    }		
}
```

Clearly callbacks don't compose in the same way as `Future`s and the `Future` based code also provides an error path, which is absent from the callback example.

### Show activity indicator while busy.

It's a good idea to display an activity indicator to the user, if they are unable to use the UI until an asynchronous callback completes.

With `Futures` this is a single line `futureResult.showActivityIndicatorWhileWaiting()`:

```swift
func loadInitialText() {
  let futureResult = readSample()
  futureResult.showActivityIndicatorWhileWaiting(onView: self.view)
  futureResult.onSuccess { (leftDocument, rightDocument) in
      .
      .   
  }.onFailure { error in
    fatalError("Unable to open sample documents, error: '\(error)'")
  }
}
```

This is implemented as a `Future` extension as:

```swift
extension Future {
    func showActivityIndicatorWhileWaiting(onView superview: UIView) -> Self {
        let activityOverlay = showActivityOverlayAddedTo(superview)
        return onComplete { _ in
            activityOverlay.removeFromSuperview()
        }
    }
}
```

Neat. The activity indicator will be displayed until the `Future` completes; whether successfully or in failure state.

### See also

* [Bright Futures](https://github.com/Thomvis/BrightFutures)
* [Searching for a Swift Future library]({% post_url 2016-01-20-searching-for-a-future-library %})
* Wikipedia entry on: [Futures and Promises](https://en.wikipedia.org/wiki/Futures_and_promises)
