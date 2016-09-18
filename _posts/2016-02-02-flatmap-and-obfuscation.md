---
layout: post
title: "Superpowers / obfuscation with map & flatMap"
tags: [Swift, iOS, Future, map, flatMap, functional-composition]
date: 2016-02-02

excerpt_separator: <!--more-->
---
Many Swift developers will reach for `map` when they want to transform the elements of an array:

```swift
let twos = (1...10).map { $0 * 2 }
twos // [2,4,6 ... 20]
```

however fewer developers use `map` with an `Optional`:

```swift
// UIImage(named:) has a signature: String -> UIImage?
let imageSize = UIImage(named: "anImage").map {$0.size}
imageSize // a 'CGSize?' or more explicitly 'Optional<CGSize>'
```

This is only of limited interest for `Optional` as Swift has simpler built-in syntax for handling such cases.<!--more--> The code below is equivalent to the above but I think most people will agree the code is simpler and more idiomatic:

```swift
let imageSize = UIImage(named: "anImage")?.size
imageSize // a 'CGSize?' identical to 'map' example
```

In both these cases you can think of `map` as operating on contained or wrapped values. In the first example the container is an `Array`; in the second example the container is an `Optional`. This becomes more interesting when you interact with other types such as:

* [Result<T, E: ErrorType>](https://github.com/antitypical/Result)
* [Future<T, E: ErrorType>](https://github.com/Thomvis/BrightFutures)

For example using `map` on a `Result` value:

```swift
// transforms a Result<Int, JSONError> to a Result<String, JSONError>
let idResult = intForKey(json, key:"id").map { id in String(id) }
```

Using `map` on a `Future`:

```swift
// open() returns Future<TextDocument, AnyError>
document.open().map {updateView ($0)}
}
```

In all these cases `map` is operating on the element inside the container type; where the container type is one of: `Array`, `Optional`, `Result`, `Future`.

## flatMap

Consider the difference between `map` and `flatMap` below:

```swift
// map:
let arrayOfArrayOfChars = ["array", "of", "arrays"].map {Array($0.characters)}
arrayOfArrayOfChars // [["a", "r", "r", "a", "y"],["o", "f"],["a", "r", "r", "a", "y", "s"]]

// flatMap:
let arrayOfChars = ["array", "of", "characters"].flatMap {Array($0.characters)}
arrayOfChars // ["a", "r", "r", "a", "y", "o", "f", "c", "h", "a", "r", "a", "c", "t", "e", "r", "s"]
```

when the function passed to `map` has a signature `T -> [T]` *and* you want the result of the mapping to be `[T]` not `[[T]]` replace `map` with `flatMap`. Again generalising `Array` to any container type, the same holds true for `Optional`:

```swift
// UIImagePNGRepresentation has the type signature: UIImage -> NSData?

let doubleOptionalData = UIImage(named: "anImage").map(UIImagePNGRepresentation)
doubleWrappedData // Optional<Optional<NSData>> or NSData??

let optionalData = UIImage(named: "anImage").flatMap(UIImagePNGRepresentation)
optionalData //  Optional<NSData> or NSData?
```

Here `flatMap` ensures we only have one level of `Optional` container.

---
<br />
A final example from a live project. I've written the same method twice, once in idiomatic Swift, once using `map` and `flatMap`.

Idiomatic version:

```swift
func readSampleText() -> String {
    guard let
        assetData = NSDataAsset(name: "SampleText1"),
        text = NSString(data:assetData.data, encoding: NSUTF8StringEncoding) else {
            return ""
    }
    return text as String
}
```

`map`, `flatMap` version:

```swift
func readSampleText() -> String {
    return NSDataAsset(name: "SampleText1").flatMap { assetData in
        NSString(data:assetData.data, encoding: NSUTF8StringEncoding)
    }.map { text in
        text as String
    } ?? ""
}
```

### Final thoughts

For `Optional` values, I think the idiomatic version wins by virtue of being understood instantly by other Swift developers. However the `map` and `flatMap` version is often the best approach when using other container types such as [`Result` ](https://github.com/antitypical/Result) and [`Future` ](https://github.com/Thomvis/BrightFutures). I hope that over time the use of `map` and `flatMap` on values other than `Array` will become familiar to mainstream Swift developers. I find that when using `map` and `flatMap`, my code becomes simpler as I think in terms of data transformation rather than state.

### See also

* [Railway oriented programming](http://fsharpforfunandprofit.com/rop/).
* [I, for One, Welcome Our New Haskell Overlords](http://robnapier.net/haskell-overlords)
* [What do map() and flatMap() really do?](http://sketchytech.blogspot.co.uk/2015/06/swift-what-do-map-and-flatmap-really-do.html)
* [`Optional` type on Apple's GitHub repository](https://github.com/apple/swift/blob/master/stdlib/public/core/Optional.swift)
* Higher-kinded types in [Completing Generics](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160229/011666.html)
* [Functor and Monad in Swift](http://www.javiersoto.me/post/106875422394)
* [From Callback to Future -> Functor -> Monad](https://medium.com/@yelouafi/from-callback-to-future-functor-monad-6c86d9c16cb5#.tp71xzufg)
