---
title: "Installing Ubuntu 10.04.1 on VMWare"
tags: "sysadmin"
date: 2011-05-12
layout: post
---
From time to time I require a fresh VMWare Ubuntu server installation.  Each time I attempt an installation I have to resort to Google to get the basics to work. Here's a quick note to myself, (a sysadmin challenged developer), so next time it's all in one place.

I'm installing Ubuntu 10.04.1 long term support using an ISO `ubuntu-10.04.1-server-amd64.iso`

First I update the repositories and install any updated libraries:
```
sudo apt-get update
sudo apt-get upgrade
```

The default installation doesn't come with an SSH Server. To install SSH:
```
sudo apt-get install ssh openssh-server
```

Next install vim:
```
sudo apt-get install vim-nox
```

Set the timezone:
```
sudo dpkg-reconfigure tzdata
```

... the rest then normally falls into place.

###Helpful References
Confused by the differences between `/etc/profile`, `/etc/environment`, `/etc/profile.d/*`, `~/.bashrc`, `~/.profile`, `~/.bash_profile`. It's all here: [Shell initialization files](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_01.html)
