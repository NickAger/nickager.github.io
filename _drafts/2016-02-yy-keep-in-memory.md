---
layout: post
title: "Keep in memory"
date: 2016-02-xx
excerpt_separator: <!--more-->
---
When you have an object that returns a Future, which you don't have reference to anywhere else you want to keep it in memory until it is completed eg DocumentPicker

DocumentPicker wraps around a number of classes - perhaps opensource DocumentPicker


* [`DocumentPicker.swift`](https://github.com/NickAger/iDiffView/blob/master/iDiffView/DocumentPicker.swift) [`keepOurselvesInMemory`](https://github.com/NickAger/iDiffView/blob/master/iDiffView/DocumentPicker.swift#L75)
