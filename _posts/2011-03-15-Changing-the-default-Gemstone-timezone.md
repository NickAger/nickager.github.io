---
title: "Changing the default Gemstone timezone"
date: 2011-03-15
layout: post
---
Gemstone ships with a timezone of EST. Fine if your in EST, but not so great elsewhere.

create an executable script containing the following: 

```
#!/bin/bash

$GEMSTONE/bin/topaz -l << EOF

set user SystemUser pass swordfish gems seaside

login
run
| osTZ |
System beginTransaction.
osTZ := TimeZone fromOS.
osTZ installAsCurrentTimeZone.
TimeZone default: osTZ.
TimeZoneInfo default: osTZ.
System commitTransaction.
%

logout
errorCount
EOF
```

When you execute it, Gemstone's timezone will match the timezone of your OS.
