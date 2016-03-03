---
layout: post
title: "Superpowers or obfuscation with map & flatMap"
date: 2016-02-xx
excerpt_separator: <!--more-->
---
Show examples from iDiffView comparing if let syntax with flatMap and map.

Example from natasha blog showing how you can see array flatMap as similar to Option flatMap


private static let leftURLKey = "leftURL"
private static let rightURLKey = "rightURL"
required init?(coder decoder: NSCoder) {
    super.init()

    let currentDocumentKeys = [leftURLKey, rightURLKey]
    let (leftDocument, rightDocument) = arrayToTuple(currentDocumentKeys.map{decodeDocumentUrl(decoder, forKey:$0)}.map(createDocument))

    let previousDocumentKeys = [previousLeftURLKey, previousRightURLKey]
    let (leftPreviousURL, rightPreviousURL) = arrayToTuple(previousDocumentKeys.map{decodeDocumentUrl(decoder, forKey:$0)})

    model = DiffViewModel(leftDocument: leftDocument, rightDocument: rightDocument, previousLeftURL: leftPreviousURL, previousRightURL: rightPreviousURL)
}

        private func decodeDocumentUrl(decoder: NSCoder,forKey key: String) -> NSURL?
        private func createDocument(url: NSURL?) -> DiffTextDocument?

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
