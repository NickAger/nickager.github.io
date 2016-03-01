---
title: "Setting the order cron jobs execute"
date: 2011-06-10
tags: [cron, DevOps]
layout: post
---
I had a problem where I wanted to restart my server then backup my database, but how to ensure the order is executed as intended?

It seems that `/usr/bin/run-parts` is the script that executes the scripts that are stored in `/etc/cron.daily`. Inspecting the script, it simply iterates over the files in the folder so a simple way to work-out which order is simply to execute the script:

```bash
for i in cron.daily/* ; do
echo $i
done
```

which will show the order.

The trick is to prefix the files with a digit which defines the order in which the scripts will be executed.
