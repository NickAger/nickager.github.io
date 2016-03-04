---
layout: post
title: "Superpowers or obfuscation with map & flatMap"
date: 2016-02-xx
excerpt_separator: <!--more-->
---
`map` is used for transforming the elements of an array such as:

```swift
let twos = (1...10).map { $0 * 2 }
// twos == [2,4,6 ... 20]
```

it is but it also has extra super-powers:




`CollectionType`

Show examples from iDiffView comparing if let syntax with flatMap and map.

```
public enum Optional<Wrapped> : _Reflectable, NilLiteralConvertible {
    case None
    case Some(Wrapped)
    /// Construct a `nil` instance.
    public init()
    /// Construct a non-`nil` instance that stores `some`.
    public init(_ some: Wrapped)
    /// If `self == nil`, returns `nil`.  Otherwise, returns `f(self!)`.
    @warn_unused_result
    public func map<U>(@noescape f: (Wrapped) throws -> U) rethrows -> U?
    /// Returns `nil` if `self` is nil, `f(self!)` otherwise.
    @warn_unused_result
    public func flatMap<U>(@noescape f: (Wrapped) throws -> U?) rethrows -> U?
    /// Create an instance initialized with `nil`.
    public init(nilLiteral: ())
}
```

from https://github.com/apple/swift/blob/master/stdlib/public/core/Optional.swift




Compare:
NSDataAsset.init?(name: String)

String -> NSDataAsset?

NSString.init?(data: NSData, encoding: UInt)

NSData -> NSString?

NSString -> String

func readSampleText() -> String {
    guard let
        assetData = NSDataAsset(name: "SampleText1"),
        text = NSString(data:assetData.data, encoding: NSUTF8StringEncoding) else {
            return ""
    }
    return text as String
}



with:

func readSampleText() -> String {
    return NSDataAsset(name: "SampleText1").flatMap { assetData in
        NSString(data:assetData.data, encoding: NSUTF8StringEncoding)
    }.map { text in
        text as String
    } ?? ""
}


@IBAction func leftFolderPressed(folderButton: UIView) {
    DocumentPicker.show(from: folderButton, previousURL: viewModel.previousLeftURL, parentViewController: self)
        .map { self.openDocument($0, whenOpenDo: self.whenLeftOpenDo) }
}

@IBAction func rightFolderPressed(folderButton: UIView) {
    DocumentPicker.show(from: folderButton, previousURL: viewModel.previousRightURL, parentViewController: self)
        .map { self.openDocument($0, whenOpenDo: self.whenRightOpenDo)}
}


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
        private func createDocument(url: NSURL?) -> DiffTextDocument? {
            return url.map(DiffTextDocument.init)
        }

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
