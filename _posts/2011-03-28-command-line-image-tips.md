---
title: "Command-line image tips"
date: 2011-03-28
tags: "devops"
layout: post
---

#### Identify
```bash
$ identify IMG_4417.JPG
IMG_4417.JPG JPEG 2112x2816 2112x2816+0+0 8-bit DirectClass 2.543MiB 0.000u 0:00.000
```

### Using the command line calculator

Non-interactively:

```
echo "scale=2; 2112 / 2816" | bc
```

Interactively:

```
$ bc
bc 1.06.95
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
scale=2; 2112 / 2816
.75
```
