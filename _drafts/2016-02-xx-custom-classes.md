---
layout: post
title: "Custom classes in Objective-C"
date: 2016-02-xx
excerpt_separator: <!--more-->
---
Describe the motivation - white label product.

Differentiate between customisations and configuration. Where customisation is something that is specific to one or two sites. Whereas configuration is something which needs configuration across all sites.

* I (Nick Ager) saw a danger that we were conflating configuration with customisation which led to more and more conditional code paths within our core, with the associated testing complexity in our code-base.
* I (Nick Ager) also wanted to move to a simpler, testable stable core, where we could add customisation without changing the core.
* customClasses allow class behaviour to be overridden at runtime on a class by class basis with no additional conditional paths in the core

How to avoid an explosion in computational logic

Was is successful? (in another blog - problem of fragile base class, real problem is in the database)

Retrospectively looking at these old presentations I see:
standard build has replaced the need to make multiple releases on the same core
The analysis of the problem remains valid, however the solution focused on an implementation in iOS. The real problem however is in the framework.
