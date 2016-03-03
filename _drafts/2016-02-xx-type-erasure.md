---
layout: post
title: "Type Erasure in Swift"
date: 2016-02-xx
excerpt_separator: <!--more-->
---
[Zip3 gist](https://gist.github.com/NickAger/d6bfa79cd3e8abb77dd6)

http://robnapier.net/erasure

http://stackoverflow.com/questions/33843038/define-a-swift-protocol-which-requires-a-specific-type-of-sequence

let sequence = AnySequence(zip(previousArray, nextArray, self as [Diff]))

* [Type erasure with `AnyError`](https://github.com/NickAger/iDiffView/commit/dca2d6811974721dd65364a70231b6f6f10d7d82)
