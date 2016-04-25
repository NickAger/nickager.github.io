---
layout: post
title: "Updating an Objective-C library for Swift"
date: 2016-04-25
excerpt_separator: <!--more-->
---
Recently I updated an Objective-C [library](https://github.com/NickAger/aerogear-diffmatchpatch-ios/tree/ARC-conversion) for improved Swift interoperability. The Objective-C library hadn't been touched for a while to the extent that it still used manually memory management rather than ARC. Converting a pre-ARC library added additional challenges.

All the changes made are contained in this [pull request](https://github.com/aerogear/aerogear-diffmatchpatch-ios/pull/6). I also added a [Travis build CI](https://travis-ci.org/NickAger/aerogear-diffmatchpatch-ios) for the [library](https://github.com/NickAger/aerogear-diffmatchpatch-ios/tree/ARC-conversion).
<!--more-->

## Unmodified Swift Import

First lets look at the Swift imports for the unmodified Objective-C library. The library contains over forty methods, for the sake of brevity I'll focus on two which are representative of the less-than-ideal initial API the library presents to Swift. The first method:

```swift
func diff_mainOfOldString(text1: String!, andNewString text2: String!) -> NSMutableArray!
```

Before updating the library, I wrapped the method call inside another method which presented a more idiomatic Swift interface:

```swift
func diff_mainOfOldStringSwift(text1: String, andNewString text2: String) -> [Diff] {
      let diffs = diff_mainOfOldString(text1, andNewString:  text2)
      return diffs as NSArray as! [Diff] // see http://stackoverflow.com/questions/25837539/how-can-i-cast-an-nsmutablearray-to-a-swift-array-of-a-specific-type
}
```

Note the hideous double cast: `diffs as NSArray as! [Diff]`; necessary to move from `NSMutableArray` to `[Diff]`

The wrapping method's signature highlights what is wrong with the original (apart from the horrible `diff_` prefix):

* The wrapper removes the implicitly unwrapped optional parameters by changing `String!` to `String`
* The wrapper returns `NSMutableArray` which even in Objective-C world, I would have thought would be a contravention of most sensible coding guidelines.
* The wrapper returns `[Diff]`, clearly stating the purpose of the method.


The second method is the constructor method `init`:

```swift
public class Diff : NSObject, NSCopying {
    public init!(operation anOperation: Operation, andText aText: String!)  
}
```

Again the `String` parameter is unnecessarily an implicitly unwrapped optional as is the `init!` itself. With `init!` Swift is playing safe saying "I can't guarantee this constructor will return a valid object, it may just return nil, but you can use it as though it constructed correctly."

In most cases its possible to treat the return `Diff!` object directly as a `Diff` for example:

```swift
func nullDiff() -> Diff {
    let noDiff = Diff(operation: .DiffEqual, andText:"")
    return noDiff
}
```

However in my code, I discovered that sometimes `Diff!` objects aren't treated as `Diff`s, for example:

```swift
// compile error: "contextual type 'AnySequence<(Diff, Diff)>' cannot be used with array literal return [(noDiff, noDiff)]"
func nullDiffSequence() -> AnySequence<(Diff,Diff)> {
    let noDiff = Diff(operation: .DiffEqual, andText:"")
    return [(noDiff, noDiff)]
}
```

or perhaps the error generated in this similar example makes it slightly clearer where Swift sees the problem :

```swift
// compile error: "cannot invoke initializer for type 'AnySequence<_>' with an argument list of type '([(Diff!, Diff!, Diff!)])'"
func nullDiffSequence2() -> AnySequence<(Diff, Diff, Diff)> {
    let noDiff = Diff(operation: .DiffEqual, andText:"")
    return AnySequence([(noDiff, noDiff, noDiff)])
}
```

The above two examples show that for Swift `Diff!` is not **always** equivalent to `Diff`.

For more information on `AnySequence` see my previous post on [Type Erasure with AnyError]({% post_url 2016-03-08-AnyError %})

## Improving the Objective-C library for Swift

My initial attempt at improving the library was to wrap the Objective-C header in `NS_ASSUME_NONNULL_BEGIN` …
`NS_ASSUME_NONNULL_END`. However this failed as the library still used manual memory management with `dealloc` methods which manually set properties to 'nil' to ensure the memory was freed:

```objc
@implementation Diff

- (void)dealloc
{
  self.text = nil; // Error: Null passed to a callee that requires a non-null argument

  [super dealloc];
}

@end
```

### Down the rabbit-hole of modernising the Objective-C library
After trying various work-arounds to `dealloc`s penchant for setting properties to nil, I decided to do-the-right-thing and convert the library from manual memory management to ARC. In the process I also used the "Convert to modern Objective-C syntax" tool which:

* converted NSArray indexing to use the `[]` syntax
* converted boxed literals to use the `@()` syntax
* favours dot syntax over square brackets
* converted `id` to `instancetype` on `init..` methods

I then manually converted to use automatic synthesis of properties by removing the instance variables backing store and ensured all access to the instance
variables to go through the property e.g. `_editCost = 5` becomes `self.editCost = 5`.

I also reworked the public methods to return `NSArray` rather than `NSMutableArray` and added Objective-C generics annotation to arrays as:

```objc
- (NSArray<Diff *> *)diff_mainOfOldString:(NSString *)text1 andNewString:(NSString *)text2;
```

The rather hideous looking `(NSArray<Diff *> *)` translates in Swift to a much clearer `[Diff]`

## Final thoughts
Making a pre-ARC library expose an API in idiomatic swift proved to be a fair amount of effect. To recap, the old API imported as:

```swift
func diff_mainOfOldString(text1: String!, andNewString text2: String!) -> NSMutableArray!
```

and after improving the Swift interop imported as:

```swift
func diff_mainOfOldString(text1: String, andNewString text2: String) -> [Diff]
```

Clearly my initial expedient solution of using wrapper methods and judicious casts worked but I felt my code was quickly becoming difficult to maintain, even though it was littered with comments explaining the Objective-C -> Swift API.

Although for one developer it might be difficult to rationally justify the time spent "Swiftifying" an Objective-C library, amortising the time over multiple developers quickly makes-up the time spent.
