---
title: "Lazily avoiding Optional"
date: 2016-05-28
tags: [Swift, Optional]
layout: post
---
Show the error when a non optional property isn.t defined in init


Here I don't have to define the property as Optional
```
lazy private var baseMessageHandler: BaseMessageHandler = {
    return BaseMessageHandler(messageSender: self.dataSource.messageSender)
}()
```
