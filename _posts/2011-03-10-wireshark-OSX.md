---
title: "Wireshark on OSX"
date: 2011-03-10
tag: [DevOps, OSX]
layout: post
---
When trying to monitor an interface using Wireshark on my Mac - I'm greeted with:

```
No Interfaces Available In Wireshark Mac OS X
```

the fix is:

```
$ sudo chmod 644 /dev/bpf*
```

See: [No Interfaces Available In Wireshark Mac OSX](http://langui.sh/2010/01/31/no-interfaces-available-in-wireshark-mac-os-x/)
