---
layout: post
title: "Joy of Futures"
date: 2016-02-xx
excerpt_separator: <!--more-->
---
As most scarred programmers will attest, doing threads properly in the face of shared mutable state across threads is hard. Let's review why:


The problem
Currently Nurse uses performSelectorInBackground:blockUi: for it's web service calls. This using a background thread to execute the call. performSelectorInBackground:blockUi: results in threading abstraction leakage into the UI and model layer. Explicit threading is bad as it requires locks which are bad:
Locks do not compose
Locks breaks encapsulation (you need to know a lot!)
Taking too few locks
Taking too many locks
Taking the wrong locks
Taking locks in wrong order
Error recovery is hard
Threaded code leads to impossible to reproduce bugs - it's non deterministic - you only find out about the issue on-site.
Proposal
Doctor however (mainly) uses asynchronous calls eliminating threading issues from the UI.
Asynchronous events are those occurring independently of the main program flow. Asynchronous actions are actions executed in a non-blocked scheme, allowing the main program flow to continue progressing
The proposal is to use the best of Doctor and supplement with the promise protocol to alleviate the problem of nesting asynchronous calls and the unify all data received from the model. With promises the client won't care if the data is cached or needs to be downloaded. Promises also allow the error handling for multiple web service calls to be unified. Model objects will only return promises.


Instead I like to model apps with a clear threading model. Any threading that occurs is locked in a box and the use of mutable shared state across threads is eliminated.

Enter futures and promises.



* Change from using call-backs to [Futures/Promises](https://github.com/Thomvis/BrightFutures):
  * [Changed the fileChangedMessage to display use a `Future` interface](https://github.com/NickAger/iDiffView/commit/e3b377da7f6e1a0a4708672632741f31f1f0eb47)
  * [Use Future throughout](https://github.com/NickAger/iDiffView/commit/dca2d6811974721dd65364a70231b6f6f10d7d82)
  * [WIP rework sync callbacks using futures](https://github.com/NickAger/iDiffView/commit/20ee2683636e29a5835a71cf128241ab40521300)
* [`showActivityIndicatorWhileWaiting`](https://github.com/NickAger/iDiffView/commit/20ee2683636e29a5835a71cf128241ab40521300)
* [Type erasure with `AnyError`](https://github.com/NickAger/iDiffView/commit/dca2d6811974721dd65364a70231b6f6f10d7d82)
