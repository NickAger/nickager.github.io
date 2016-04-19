---
layout: post
title: "Avoiding Swift's [Any]"
date: 2016-04-19
excerpt_separator: <!--more-->
---
In my previous post: "[Unexpected behaviour with Swift's [Any]]({% post_url 2016-04-19-swift-any-arrays %})", I declared a nested array of integers as:

```swift
let a : [Any] = [1,2,[3],[4,[5,6]],[[7]], 8]
```

Using `Any` feels like a code smell; we have a compiler with a sophisticated type system, but by using `Any` I'm effectively saying, "ignore all the type-checking the compiler performs, instead I'll rely on my own knowledge of the types". Experience shows I am not as knowledgable as the compiler especially after some time has elapsed and I'm trying to add a new feature... <!--more-->That said, my intent isn't to suppress the compiler's type checking, I initially didn't know how to express a heterogeneous array without resorting to `Any`. However I've been learning [Haskell](https://www.haskell.org) where the way to express such heterogeneous arrays is by using a [sum type](https://en.wikipedia.org/wiki/Tagged_union), which in Swift are defined using [`enum`](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html)s. Let's start by defining an enum, which will hold either `Int` or `Array` values:

```swift
enum IntOrArray {
    case intValue(Int)
    case arrayValue([IntOrArray])
}
```

the array:

```swift
let a : [Any] = [1,2,[3],[4,[5,6]],[[7]], 8]
```

can then be expressed in an equivalent type-safe way as:

```swift
let a : [IntOrArray] = [.intValue(1), .intValue(2), .arrayValue([.intValue(4), .arrayValue([.intValue(5), .intValue(6)])]), .arrayValue([.arrayValue([.intValue(7)])]), .intValue(8)]
```

A `process` function is easy to write without resorting to the horrible hacks documented my [previous post]({% post_url 2016-04-19-swift-any-arrays %}):

```swift
func process(anArray : [IntOrArray]) {
    for element in anArray {
        switch(element) {
        case .intValue(let intValue):
            print("intValue = \(intValue)")
        case .arrayValue(let arrayValue):
            process(arrayValue)
        }
    }
}

process(a)
```

It's also fun to write a flatten function without any mutable variables:

```swift
func flatten(anArray : [IntOrArray]) -> [Int] {
    return anArray.flatMap (flattenAnElement)
}

func flattenAnElement (element : IntOrArray) -> [Int] {
    switch element {
    case .intValue(let intValue):
        return [intValue]

    case .arrayValue(let arrayValue):
        return flatten(arrayValue)
    }
}

flatten(a) // [1,2,4,5,6,7,8]
```

Swift's [enumerations](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html) with associated values is a language feature which can often be used instead of class hierarchies, benefit from being [value types](https://en.wikipedia.org/wiki/Value_type) and frequently express the intent of the code much more succinctly than the class based alternative.

A playground containing the code in this post can be downloaded [here](/files/blog/2016-04-20-avoiding-any-arrays/[IntOrArray].playground.zip)
