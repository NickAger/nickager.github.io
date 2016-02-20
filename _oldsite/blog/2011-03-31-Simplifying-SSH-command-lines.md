---
title: "Simplifying  SSH command lines"
tags: "sysadmin"
date: 2011-03-31
---
I frequently forget the parameters required for SSHing into my servers. Fortunately it's straight-forward to define SSH configurations. For example say I frequently SSH into a site with the following SSH command-line:

```
ssh -X -C -L 8888:127.0.0.1:80 seasideuser@myamazingsite.com
```

This can be replaced with the following entry in `~/.ssh/config:

```
Host myamazingsite
        User seasideuser
        LocalForward 8888 127.0.0.1:80
        HostName myamazingsite.com
        ForwardX11 yes
        ForwardX11Trusted yes
        Compression yes
```

Now instead of having to remember all the parameters, I can simply type:

```
ssh myamazingsite
```
___

Update: [Norbert](http://norbert.hartl.name/) pointed out that adding `ForwardAgent yes` in the host configuration allows you to connect to a third host while being logged into a remote host. He notes:

> If you enable agent forwarding than you can connect/rsync from the remote host to any other host that has your keys installed. Key requests are rooted back to your work station and this way you keep your private key at a single place.

On my Mac with OS 10.6.x I found that agent forwarding didn't work until I added my key to the Apple keychain, with the following:

```
ssh-add -K ~/.ssh/id_rsa 
```

With agent forwarding the  `~/.ssh/config` entry reads:

```
Host myamazingsite
        User seasideuser
        LocalForward 8888 127.0.0.1:80
        HostName myamazingsite.com
        ForwardX11 yes
        ForwardX11Trusted yes
        Compression yes
        ForwardAgent yes
```
