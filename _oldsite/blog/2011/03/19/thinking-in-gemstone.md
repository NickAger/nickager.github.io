---
title: "Thinking in Gemstone"
date: 2011-03-19
tags: "Gemstone"
---
!!Abort
When I first started using Gemstone, the term abort was flying around. This confused me greatly.

Surely aborting a database rolls back a transaction.

In fact what it does in Gemstone is ensure that the data in the Gem is consistant with the copy in the stone.

read all about it....

!!multithreading
Unlike Pharo and Squeak which have a schedular a basic Gem doesn't possess such a thing. Instead you run separate gems for garbage collection, background tasks, serving requests.

This manifests itself when debugging. As soon as you start a server, gem tools UI freezes; blocks until it hits a break point. Not you can always start two editing sessions, and debug from one and edit in the other....

kill them with Ctrl-Alt .

!!Gemstone hangs when starting up
check for old lock files hanging around:
=ls /opt/gemstone/locks/

- Difference between copying the repository and backing it up.
- where the various repositories are located.
- what the various running processes are (maintenance gem, MFC) and the service gem

crucial lines (copied from the installer) to recover from a hosed instance before restoring a backup:
= cp /opt/gemstone/product/bin/extent0.seaside.dbf \
=        /opt/gemstone/product/seaside/data/extent0.dbf
= chmod 644 /opt/gemstone/product/seaside/data/extent0.dbf


sharing monitScripts

ObjectLog

Transcript shows up in the normal transcript!


how to do a backup and restore

_

We've run into some problems with our maintenance process. It turned
out that the machine we were running on is virtualised and ran out of
capacity. Don't think it had much to do with us though. In our quest
to figure out what is going on, we found that expiring seaside
handlers was taking quite some time here (kill -USR1 <pid> to the
rescue):

# RcCounter >> _calculateValue @IP 24  [GsMethod 12517889]
# RcCounter >> value @IP 18  [GsMethod 12517121]
# WARcLastAccessEntry >> isExpired:updating: @IP 13  [GsMethod 116831745]

It looks like it might be time for a #cleanupCounter ... #cleanupCounter eliminates bunches of invalid sessions and that might be the root cause of the long _calculateValue ...
