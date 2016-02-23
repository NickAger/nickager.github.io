---
title: "Thinking in Gemstone"
date: 2011-03-19
tags: "Gemstone"
layout: post
---
## Abort
When I first started using Gemstone, the term abort was flying around. This confused me greatly.
Surely aborting a database rolls back a transaction?
In Gemstone 'abort' ensures that the data in the Gem is consistant with the copy in the stone.

## Multithreading
Unlike Pharo and Squeak which have a scheduler a basic Gem doesn't possess such a thing. Instead you run separate gems for garbage collection, background tasks, serving requests.

This manifests itself when debugging. As soon as you start a server, gem tools UI freezes; blocks until it hits a break point. Note you can always start two editing sessions, and debug from one and edit in the other.... kill any huge debugging sessions with Ctrl-Alt .

## Gemstone hangs when starting up
check for old lock files hanging around:
```
ls /opt/gemstone/locks/
```

crucial lines (copied from the installer) to recover from a hosed instance before restoring a backup:
```
cp /opt/gemstone/product/bin/extent0.seaside.dbf \
        /opt/gemstone/product/seaside/data/extent0.dbf
chmod 644 /opt/gemstone/product/seaside/data/extent0.dbf
```
