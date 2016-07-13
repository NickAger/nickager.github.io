---
title: "flatMaps evil twin OR valuable twin?"
date: 2016-07-14
tags: [Swift, flatMap, Haskell, functional programming]
layout: post
---
- Idea write the post in a swift playground...

Many programmers what to rid themselves of Optional values as soon as possible. Let's take an example.

```swift
var s = "00:04:59\n00:05:00\n00:00:01\n00:06:32"
```

parsing numbers.  Discuss different design options.


```swift
let lines = splitIntoLines(callsString)
let calls = lines.flatMap(Call.init(line:))
```








```swift
struct CallDuration {
    var hours : Int
    var minutes : Int
    var seconds : Int

    func callCost() -> CallCost {
        if minutes < 5 && hours == 0  {
            return ((minutes * 60) + seconds) * 3
        }
        let billedMinutes = (seconds == 0) ? minutes : minutes + 1
        return (billedMinutes + (hours * 60)) * 150
    }

    var totalSeconds: Seconds {
        return seconds + (minutes * 60) + (hours * 3600)
    }
}
```



See also: Changes to the Swift standard library in 2.0 betas 2..<5
http://airspeedvelocity.net/2015/07/23/changes-to-the-swift-standard-library-in-2-0-betas-2-5/
Flat Map

Missed from my 2.0b1 changes post (shame on me) was a third kind of flatMap.

1.2 brought us flatMap for collections – given an array, and a function that transforms elements into arrays, it produces a new array with every element transformed, and then those arrays “flattened” into a single array. For example, suppose you had a function, extractLinks, that took a filename and returned an array of links found in that file:

func extractLinks(markdownFile: String) -> [NSURL]
If you had an array of filename strings (say from a directory listing), and you wanted an array of the links in all the files, you could use this function with flatMap to produce a single array (unlike map, which would generate an array of arrays):

let nestedArrays: [NSURL] = markdownFiles.flatMap(extractLinks)
There was also a flatMap for optionals. Given an optional, it takes a function that takes the possible value inside the optional, and applies a function that also returns an optional, and “flattens” the result of mapping an optional to another optional. For example, Array.first returns the first element of a collection, or nil if the array is empty and has no such element. Int.init(String) takes a string, and if it is a representation of an integer, returns that integer, or nil if it isn’t. To take the first element of an array, and turn it into an optional integer, you could use flatMap (unlike map, which will return an optional of an optional of an integer):


let a = ["1","2","3"]
let i: Int? = a.first.flatMap { Int($0) }
So what’s the new third kind of flatMap? It’s a mixture of the two – for when you have an array, and want to transform it with a function that returns an optionals, discarding any transforms that return nil. This is logical if you think of optionals as like collections with either zero or one element – flatMap would discard the empty results, and flatten the single-element collections into an array of elements.

For example, if you have an array of strings, and you want to transform it into integers, discarding any non-numeric strings:


let strings = ["1","2","elephant","3"]
let ints: [Int] = strings.flatMap { Int($0) }
// ints = [1,2,3]
If you’ve been following this blog for a while, you’ll recognize this is a function we’ve defined before as mapSome.

By the way, all these examples have been pulled from the book on Swift that Chris Eidhof and I have been writing. The chapter on optionals has just been added to the preview.

from: http://natashatherobot.com/swift-when-the-functional-approach-is-not-right/
re flatMap
Instead of thinking nested arrays, think arrays of contained values. It flattens the array by pulling the values out of the container and then maps over the array.

let arr1: [[Int]] = [[], [2]]
let arr2: [Optional] = [.none, .some(2)]

These to are pretty much the same, in the first the container is an array and in the second it is an optional.
see also - http://natashatherobot.com/swift-2-flatmap/
