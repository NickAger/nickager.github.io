---
layout: post
title: "Unexpected behaviour with Swift's [Any]"
date: 2016-04-19
excerpt_separator: <!--more-->
---
Any idea why the following code is generating a runtime exception:

![](/images/blog/2016-04-19-swift-any-arrays/any-array-exception.png)

Adding an explicit type declaration solves the problem:

![](/images/blog/2016-04-19-swift-any-arrays/any-array-no-exception.png)

But why?
<!--more-->
If you Cmd-? over `let a` you discover that the inferred type in the first example is: `[NSObject]` not `[Any]`. It is then, perhaps, a little clearer why the runtime is generating the error:

```
fatal error: array cannot be bridged from Objective-C
```
The runtime is throwing up its hands and saying it doesn't know how to convert  from `[NSObject]` to `[Any]`, which makes a little more sense.

However it feels like this should be picked up by the compiler rather than produce a runtime exception, so I've filed a bug report with Apple to that effect: [rdar://25799364](http://openradar.appspot.com/radar?id=6151575726718976)  

## Converting Any to [Any]

Different problem, but again `Any` is involved in causing a runtime exception:

![](/images/blog/2016-04-19-swift-any-arrays/any-to-any-array.png)

Examining the error message:

```
Could not cast value of type 'Swift.Array<Swift.Int>' to 'Swift.Array<protocol<>>'
```

... and noting that `Any` is defined as:

```swift
public typealias Any = protocol<>
```

... means the error can be translated as:

```
Could not cast value of type 'Swift.Array<Swift.Int>' to 'Swift.Array<Any>'
```

This seems counter intuitive - "Surely all types can be converted into `Any`". However [Airspeed Velocity](https://airspeedvelocity.net) on stackoverflow nudged my understanding in the right directly with this [answer](http://stackoverflow.com/questions/31697093/cannot-pass-any-array-type-to-a-function-which-takes-any-as-parameter#31698054)

> While every type conforms Any, this is not the same as it being a universal implicit superclass that all types inherit from.
> .
> .
> Since value types are held directly in the array, the ([Any]) array would be a very different shape (to the [Int] array) so under the hood the compiler would have to do the equivalent of this:
>
> anArray.map { $0 as Any }

which allows me to write a conversion from `Any` to `[Any]`:

```swift
func convertToArray(value: Any) -> [Any] {
    let nsarrayValue = value as! NSArray
    return nsarrayValue.map {$0 as Any}
}
```

The code then works:
![](/images/blog/2016-04-19-swift-any-arrays/any-to-any-array-2.png)

A playground containing these examples can be downloaded [here](/files/blog/2016-04-19-swift-any-arrays/[Any].playground.zip)

Hopefully this will help someone (or my future self), not waste so much time with confusing `Any` related problems.
