---
layout: post
title: "Swift libraries"
date: 2015-12-04
tags: [Swift, iOS]
---
Some potentially useful Swift libraries:

{: .table-striped}
| Area                                | Library      | Comments  |
|-------------------------------------|------------|----------|
| GCD                                 | [Async](https://github.com/duemunk/Async)| appears to be a simple useful framework |
| Future, Promises|[BrightFutures](https://github.com/Thomvis/BrightFutures)| Swift futures and promises |
| Mocking HTTP                        | [Nocilla](http://mr-v.github.io/http-testing-in-swift-with-nocilla/) |                 |
| NSDate                              | [TimePiece](https://github.com/naoty/Timepiece) | Various NSDate helpers  |
| Keychain                            | [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) | Keychain API needs wrapping  |
| JSON                                | [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON), [Argo](https://github.com/thoughtbot/Argo), [Gloss](https://github.com/hkellaway/Gloss), [Freddy](https://github.com/bignerdranch/Freddy), ... | Argo is modelled after Haskell's [Aeson](https://www.schoolofhaskell.com/school/starting-with-haskell/libraries-and-frameworks/text-manipulation/json) which might put of some developers; [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) looks possibly simpler and [Gloss](http://harlankellaway.com/Gloss/) appears to be inspired by Argo. Freddy is type safe and idiomatic.. |
| Testing                             | [Assertions](https://github.com/antitypical/Assertions), [Quick](https://github.com/Quick/Quick), [FBSnapShotTestCase](https://github.com/facebook/ios-snapshot-test-case) | Assertions: This is a Swift µframework providing simple, flexible assertions for XCTest in Swift; Quick: Quick is a behavior-driven development framework for Swift and Objective-C. Inspired by RSpec, Specta, and Ginkgo. FBSnapShotTestCase: Compares a snapshot to a "reference image" stored in your source code repository and fails the test if the two images don't match. |
| QuickCheck style testing| [Fox](http://fox-testing.readthedocs.org/en/latest/), [SwiftCheck](https://github.com/typelift/SwiftCheck)| Similar to [QuickCheck on Haskell](https://wiki.haskell.org/Introduction_to_QuickCheck2), see [presentation](http://2014.funswiftconf.com/speakers/brian.html) on Fox and the [Erlang Elevator QuickCheck](http://advanced-erlang.com/videos/test-elevator-software-with-quickcheck/) example mention in the [talk](http://2014.funswiftconf.com/speakers/brian.html)|
| Managing complexity of interactions | [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)  | Cocoa framework inspired by [Functional Reactive Programming](https://en.wikipedia.org/wiki/Functional_reactive_programming). It provides APIs for composing and transforming streams of values over time |
| Result<Value, Error>                |  [Result](https://github.com/antitypical/Result) | Result<Value, Error> values are either successful (wrapping Value) or failed (wrapping Error). This is similar to Swift’s native Optional type, with the addition of an error value to pass some error code, message, or object along to be logged or displayed to the user.|
| "Libraries to simplify development of Swift programs by utilising the type system"|[TypeLift](https://github.com/typelift)|[SwiftCheck](https://github.com/typelift/SwiftCheck) (QuickCheck for Swift), [Swiftx](https://github.com/typelift/Swiftx) (Functional data types and functions for any project), [Focus](https://github.com/typelift/Focus) (Optics for Swift), [Aquifer](https://github.com/typelift/Aquifer) (Functional streaming abstractions in Swift), [Swiftz](https://github.com/typelift/Swiftz) (Swiftz is a Swift library for functional programming), [Concurrent](https://github.com/typelift/Concurrent) (Functional Concurrency Primitives), [Operadic](https://github.com/typelift/Operadics) (Standard Operators for the working Swift Librarian), [Basis](https://github.com/typelift/Basis) (Pure Declarative Programming in Swift, Among Other Things), [Algebra](https://github.com/typelift/Algebra) (Abstract Algebraic Structures in Swift)|
|code composition|[Stream](https://github.com/antitypical/Stream)|Lazy streams in Swift|
|Logging|[CleanroomLogger](https://github.com/emaloney/CleanroomLogger)|The API provided by CleanroomLogger is designed to be readily understood by anyone familiar with packages such as CocoaLumberjack and log4j|
|HTTP networking library|[Alamofire](https://github.com/Alamofire/Alamofire)|Swift version of AFNetworking|
|Functional programming in Swift|[Swiftz](https://github.com/typelift/swiftz)|Swiftz implements higher-level data types like Arrows, Lists, HLists, and a number of typeclasses integral to programming with the maximum amount of support from the type system|
|Dependency Injection|[Dip](https://github.com/AliSoftware/Dip) - iand other DI containers.|"Dip is inspired by .NET's Unity Container. See also:'Function programming in Swift' [2015 conference](http://2015.funswiftconf.com) - DI in Swift [ video](https://youtu.be/2--pYf1T6Xc). There must be other DI frameworks out there... |

<br />

I still haven't found Swift equivalents of:

{: .table-striped}
|Area | Library | Comments|
|-----|---------|---------|
|Mocking|[OCMock](http://ocmock.org)|Extensive use of Swift protocols minimises the need for mocks. Using locally defined classes for mocking see [Mocking in Swift](http://nshipster.com/xctestcase/)|
