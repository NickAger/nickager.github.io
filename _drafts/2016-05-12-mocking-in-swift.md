---
layout: post
title: "Mocking in Swift"
date: 2016-02-12
excerpt_separator: <!--more-->
---


https://speakerdeck.com/mchakravarty/adopting-functional-programming

Everything being equal - it is better to have less
"What if you could gain the same confidence in correctness with less or simpler tests"
"you would spent less time writing and maintaining, and running tests"

"A type signature is worth a thousand tests"




From http://nshipster.com/xctestcase/

Mocking can be a useful technique for isolating and controlling behavior in systems that, for reasons of complexity, non-determinism, or performance constraints, do not usually lend themselves to testing. Examples include simulating specific networking interactions, intensive database queries, or inducing states that might emerge under a particular race condition.

There are a couple of open source libraries for creating mock objects and stubbing method calls, but these libraries largely rely on Objective-C runtime manipulation, something that is not currently possible with Swift.

However, this may not actually be necessary in Swift, due to its less-constrained syntax.

In Swift, classes can be declared within the definition of a function, allowing for mock objects to be extremely self-contained. Just declare a mock inner-class, override and necessary methods:

```swift
func testFetchRequestWithMockedManagedObjectContext() {
    class MockNSManagedObjectContext: NSManagedObjectContext {
        override func executeFetchRequest(request: NSFetchRequest!, error: AutoreleasingUnsafePointer<NSError?>) -> [AnyObject]! {
            return [["name": "Johnny Appleseed", "email": "johnny@apple.com"]]
        }
    }

    let mockContext = MockNSManagedObjectContext()
    let fetchRequest = NSFetchRequest(entityName: "User")
    fetchRequest.predicate = NSPredicate(format: "email ENDSWITH[cd] %@", "@apple.com")
    fetchRequest.resultType = .DictionaryResultType

    var error: NSError?
    let results = mockContext.executeFetchRequest(fetchRequest, error: &error)

    XCTAssertNil(error, "error should be nil")
    XCTAssertEqual(results.count, 1, "fetch request should only return 1 result")

    let result = results[0] as [String: String]
    XCTAssertEqual(result["name"] as String, "Johnny Appleseed", "name should be Johnny Appleseed")
    XCTAssertEqual(result["email"] as String, "johnny@apple.com", "email should be johnny@apple.com")
}
```
