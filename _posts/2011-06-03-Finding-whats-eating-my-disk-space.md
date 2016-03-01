---
title: "Finding whats eating my disk space"
date: 2011-06-03
tags: [DevOps]
layout: post
---
Use `df` to find out how much space you have left on your disk partitions:

```bash
$ df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/xvda1            10321208   4398716   5817636  44% /
tmpfs                   305304         0    305304   0% /dev/shm
```

Then use `du` to zero in on the culprit(s):

```bash
du -h --max-depth=1 on /
```

It will tell you exactly which directory is the culprit. Then you use it down the tree, and you find out where is the big file(s) located... e.g.:

```
$sudo du -h \--max-depth=1 /var
8.2M	/var/nginx
24M	/var/log
4.0K	/var/preserve
4.0K	/var/local
80K	/var/run
18M	/var/lib
4.0K	/var/yp
4.0K	/var/db
3.6M	/var/spool
4.0K	/var/account
4.0K	/var/tmp
16K	/var/lock
2.8M	/var/www
4.0K	/var/games
4.0K	/var/nis
4.0K	/var/racoon
25M	/var/cache
4.0K	/var/opt
8.0K	/var/empty
81M	/var
```
