---
layout: post
title: "Flatmap and obfuscation"
date: 2016-02-xx
excerpt_separator: <!--more-->
---
Show examples from iDiffView comparing if let syntax with flatMap and map.

Example from natasha blog showing how you can see array flatMap as similar to Option flatMap

Show example with operators

Download playground


https://www.natashatherobot.com/swift-2-flatmap/

http://sketchytech.blogspot.co.uk/2015/06/swift-what-do-map-and-flatmap-really-do.html

Instead of thinking of nested arrays, think arrays of contained values.
If flattens the array by pulling values out of the container and then maps over the array.

let arr1:[[Int]] = [[], [2]]
let arr2:[Optional] = [.none, .some(2)]

These two are pretty much the same, in the first the container is an array and in the second it is an optional.

The idea of thinking of flatMap as dealing with containers vs just arrays makes things a lot clearer!
