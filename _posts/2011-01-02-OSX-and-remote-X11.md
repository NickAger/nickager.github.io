---
title: "OSX and remote X11"
date: 2011-01-02 14:03:00 +0000
tags: [X11, Mac, OSX, GemTools, Seaside, Gemstone, Remote Cloud]
layout: post
---
If you're using MacOS as your client and you're working with GemTools remotely through X11, you may find that it gets confusing having to switch from Mac key shortcuts such as Cmd-b, Cmd-n, Cmd-m... to the subtly different Unix key bindings of Ctrl-b, Ctrl-n, Ctrl-m...

The solution is to create a key mapping file; `~/.Xmodmap` to ensure that CMD key functions on the remote GemTools as it does on the local version. `~/.Xmodmap` contents:

```
remove Mod2 = Meta_L Meta_R
keysym Meta_L = Control_L
keysym Control_L = Meta_L
keysym Meta_R = Control_R
keysym Control_R = Meta_R
add Mod2 = Meta_L Meta_R
add Control = Control_L Control_R
```

You also need to change the preferences in the X11 mac app. Ensure the following are disabled:

* 'Follow system keyboard layout'.
* 'Enable key equivalents under X11'.

**References**: [X11: Switch Control Key To Apple/Command Key](http://www.bohemianalps.com/blog/2008/01/x11-control2command)

You'll have to logout of your remote X session before the key mapping becomes active.
