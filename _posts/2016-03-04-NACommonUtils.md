---
layout: post
title: "NACommonUtils - Swift utilities on GitHub"
tags: [Swift, iOS, Apps, App store]
date: 2016-03-04
excerpt_separator: <!--more-->
---
{% include popup-javascript.html %}
<div id="list-monster" style="display:none">
  <div style="background-color:white">
  <br />
  <p style="text-align:center">List monster from <a href="http://learnyouahaskell.com/starting-out">Learn You a Haskell for Great Good!</a></p>
  <img src="http://s3.amazonaws.com/lyah/listmonster.png" style="width:580px;height:290px;" alt="list monster" />
  </div>
</div>

I've released some common Swift utilities and extensions that I use across a number of iOS apps on [GitHub](https://github.com/NickAger/NACommonUtils.git)

{: .table-striped}
| Utility | Comment|
|---------|--------|
|ActivityOverlay|Light-weight version of [MBProgessHUD](https://github.com/jdg/MBProgressHUD) - shows a translucent HUD centred in a specified view containing an activity indicator|
|AnyError|Provides type erasing unified error type - see [Type erasure with AnyError]({% post_url 2016-03-08-AnyError %})|
|Array+Functional|`func headTail() -> (head: Element, tail: [Element])?` see <a href="#list-monster" rel="leanModal">list monster</a> |
|NSMutableAttributedString+Creation|`NSMutableAttributedString` creation helpers|
|OnePixelConstraint|Designed as a auto-layout width/height constraint that will always be 1px regardless of screen scale|
|String+LineUtils|Strings line helpers|
|UIButton+ActionBlock|Button onPressed: block extension|
|UIResponder+FindUIViewController|Walk the responder chain until we find a `UIViewController`; useful when a `UIView` needs to access `UIViewController` API|
|UIView+Autolayout|Autolayout helpers; `useAutolayout()`, `centerInView(..)`, `constrainToWidth(..)`, `constrainToHeight(..) `|

<!--more-->

## Installation

The utilities are available as a [Cocoapod](https://cocoapods.org). To incorporate them to your project add the following to your `Podfile` eg:

```ruby
target '<YourProject>' do
    pod 'NACommonUtils'
    .
    .
end
```


See [https://github.com/NickAger/NACommonUtils.git](https://github.com/NickAger/NACommonUtils.git)
