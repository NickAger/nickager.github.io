---
layout: post
title: "Shake to debug"
date: 2013-04-12
tags: [iOS, Objective-C, async, gist]
---
When trying to debug UI glitches caused by asynchronous events, I've found it useful to simulate an asynchronous event with a shake. It's easy to hook into iOS device shake notifications with:

{% gist NickAger/5425090 shake.m %}

I've used shake notifications in various debugging situations such as:

* UI glitches caused by receipt of an Apple notification.
* Testing lock screen UI without having to wait for a time-out.
* Reporting memory used, when trying to track down memory leaks - a simple alternative to Instruments leak tool - which can be used by QA.

You can trigger a shake in the simulator with: ^&#8984;Z
