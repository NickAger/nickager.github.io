title: "Haskell list operations in Swift"
date: 2017-09-25
tags: [Swift, Haskell]
layout: post
---


Movivation I find it really hard to remember `prefix` instead of Haskell's `take` 

{: .table-striped}
| Haskell                               | Swift equivalent      |
|-------------------------------------|------------|
| take n | Array.prefix(upTo:) |
| takeWhile| Array.prefix(while:)|
| drop n | Array.dropFirst , dropLast |
| find???| Array.first(where:) |

How from:  https://github.com/apple/swift/blob/master/docs/StringManifesto.md "s.prefix(upTo: i) should become s[..<i]"
Examples:

(in Haskell, so you will see what a cool syntax it has)

See also:
* [Swift Evolution: Rationalizing Sequence end-operation names](https://github.com/apple/swift-evolution/blob/9cf2685293108ea3efcbebb7ee6a8618b83d4a90/proposals/0132-sequence-end-ops.md)