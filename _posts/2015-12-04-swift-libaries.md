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
| JSON                                | [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON), [Argo](https://github.com/thoughtbot/Argo) | Argo is modelled after Haskell's [Aeson](https://www.schoolofhaskell.com/school/starting-with-haskell/libraries-and-frameworks/text-manipulation/json) which might put of some developers; [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) looks possibly simpler |
| Testing                             | [Assertions](https://github.com/antitypical/Assertions) | This is a Swift µframework providing simple, flexible assertions for XCTest in Swift  |
| Managing complexity of interactions | [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)  | Cocoa framework inspired by [Functional Reactive Programming](https://en.wikipedia.org/wiki/Functional_reactive_programming). It provides APIs for composing and transforming streams of values over time |
| Result<Value, Error>                |  [Result](https://github.com/antitypical/Result) | Result<Value, Error> values are either successful (wrapping Value) or failed (wrapping Error). This is similar to Swift’s native Optional type, with the addition of an error value to pass some error code, message, or object along to be logged or displayed to the user.|
| "Libraries to simplify development of Swift programs by utilising the type system"|[TypeLift](https://github.com/typelift)|[SwiftCheck](https://github.com/typelift/SwiftCheck) (QuickCheck for Swift), [Swiftx](https://github.com/typelift/Swiftx) (Functional data types and functions for any project), [Focus](https://github.com/typelift/Focus) (Optics for Swift), [Aquifer](https://github.com/typelift/Aquifer) (Functional streaming abstractions in Swift), [Swiftz](https://github.com/typelift/Swiftz) (Swiftz is a Swift library for functional programming), [Concurrent](https://github.com/typelift/Concurrent) (Functional Concurrency Primitives), [Operadic](https://github.com/typelift/Operadics) (Standard Operators for the working Swift Librarian), [Basis](https://github.com/typelift/Basis) (Pure Declarative Programming in Swift, Among Other Things), [Algebra](https://github.com/typelift/Algebra) (Abstract Algebraic Structures in Swift)|
|code composition|[Stream](https://github.com/antitypical/Stream)|Lazy streams in Swift|

<br />

I still haven't found Swift equivalents of:

{: .table-striped}
|Area | Library | Comments|
|-----|---------|---------|
|Dependency Injection|[Objection](http://objection-framework.org/)|See 'Function programming in Swift' [2015 conference](http://2015.funswiftconf.com) - DI in Swift [ video](https://youtu.be/2--pYf1T6Xc) |
|Mocking|[OCMock](http://ocmock.org)|Extensive use of Swift protocols minimises the need for mocks|
|Logging|[Cocoa Lumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)| |
