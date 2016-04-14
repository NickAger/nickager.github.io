---
layout: post
title: "Unix shell configuration"
date: 2015-03-02
tags: [DevOps, Unix, Linux]
excerpt_separator: <!--more-->
---
I've struggled to find an authoritative source to explain the different uses of the files: `~/.profile`, `~/.bash_profile` and `~/.bashrc`. Finally, I found a good explanation [here](https://rvm.io/support/faq#what-shell-login-means-bash-l). Quoting directly:

1. When you login graphically to your system it will read `~/.profile` so you put there settings like LANG which are important for graphical applications.
2. When you open a terminal (except Gnome-terminal & Screen) you open a login shell which sources `~/.bash_profile`
3. When you execute commands in non login shell like ssh server command or scp file server:~ or sudo(without -i) or su (without -l) it will execute `~/.bashrc`
4. `~/.bashrc` is meant for non login invocations, you should not print there any output - it makes tools like scp fail.
5. If the shell of the user is set to `/bin/sh`, you will need to edit `/etc/passwd` and set it to `/bin/bash`
