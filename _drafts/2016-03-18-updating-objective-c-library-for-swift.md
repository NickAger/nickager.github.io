---
layout: post
title: "Updating an Objective-C library for Swift"
date: 2016-03-18
excerpt_separator: <!--more-->
---
How it imported originally.

Why did I have to make it ARC compilant? Answer: ARC enabled so that I could make diff NS_ASSUME_NONNULL_BEGIN - that didn't work in the case of pre-ARC code. Changed interfaces for NSMutatableArray to NSArray to map directly to Swift Array
