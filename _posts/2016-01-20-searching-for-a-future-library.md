---
layout: post
title: "Searching for a Swift Future library"
tags: [Swift, iOS, Futures, Promises, async]
date: 2016-01-20
excerpt_separator: <!--more-->
---
[Futures and Promises](https://en.wikipedia.org/wiki/Futures_and_promises) are a fantastic abstraction for asynchronous operations which I'll write about in a future [post]({% post_url 2016-02-10-profit-from-futures %}). In Objective-C I used a version of [SHXPromise](https://github.com/MSNexploder/SHXPromise) which worked well for us.

Searching for an equivalent in Swift, I narrowed my choice to:

* [Promise Kit](http://promisekit.org)
* [Future Kit](https://github.com/FutureKit/FutureKit)
* [Bright Futures](https://github.com/Thomvis/BrightFutures)
<!--more-->

{: .table-striped}
| Library | # contributors | tests  | last update? |documentation|issues resolved|
|---------|----------------|--------|--------------|-------------|------------------|
|Promise Kit|51|yes|< week|yes|31 open, 227 closed|
|Future Kit|9|yes|10 days|Some, but limited|3 open, 6 closed|
|Bright Futures|18|yes & Travis|1 month|yes|9 open, 56 closed|

On a purely analytical survey, [Promise Kit](http://promisekit.org) appears to be the winner.

However looking at the APIs I really liked [Bright Futures](https://github.com/Thomvis/BrightFutures) clear understanding and focus on [functional composition](https://github.com/Thomvis/BrightFutures#functional-composition) which I didn't see as clearly articulated in other libraries.

My choice was [Bright Futures](https://github.com/Thomvis/BrightFutures)
