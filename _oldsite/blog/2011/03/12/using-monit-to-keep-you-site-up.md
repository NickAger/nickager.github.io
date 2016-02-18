---
title: "Using Monit to keep your site up"
tags: "sysadmin"
date: 2011-03-12
---
### sudo apt-get install monit
```bash
$ sudo apt-get install monit
```
```
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  monit
0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
Need to get 336kB of archives.
After this operation, 844kB of additional disk space will be used.
Get:1 http://us.archive.ubuntu.com/ubuntu/ lucid/universe monit 1:5.0.3-3 [336kB]
Fetched 336kB in 2s (159kB/s)
Selecting previously deselected package monit.
(Reading database ... 31214 files and directories currently installed.)
Unpacking monit (from .../monit_1%3a5.0.3-3_amd64.deb) ...
Processing triggers for ureadahead ...
ureadahead will be reprofiled on next reboot
Processing triggers for man-db ...
Setting up monit (1:5.0.3-3) ...
Starting daemon monitor: monit won't be started/stopped
	unless it it's configured
	please configure monit and then edit /etc/default/monit
	and set the "startup" variable to 1 in order to allow 
	monit to start
```


###sudo yum install monit
On AWS Linux:
```bash
$ sudo yum install monit
```
```
Loaded plugins: fastestmirror, security
Determining fastest mirrors
amzn                                                     | 2.1 kB     00:00     
amzn/primary_db                                          | 1.5 MB     00:00     
Setting up Install Process
Resolving Dependencies
--> Running transaction check
---> Package monit.x86_64 0:5.1.1-2.0.amzn1 set to be updated
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package        Arch            Version                     Repository     Size
================================================================================
Installing:
 monit          x86_64          5.1.1-2.0.amzn1             amzn          246 k

Transaction Summary
================================================================================
Install       1 Package(s)
Upgrade       0 Package(s)

Total download size: 246 k
Installed size: 548 k
Is this ok [y/N]: y
Downloading Packages:
monit-5.1.1-2.0.amzn1.x86_64.rpm                                            | 246 kB     00:00     
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing     : monit-5.1.1-2.0.amzn1.x86_64                                                1/1 

Installed:
  monit.x86_64 0:5.1.1-2.0.amzn1                                                                   

Complete!
```

####Running on AWS Linux

```$ sudo vim /etc/monit.d/gemstone```

```
check process nginx with pidfile /var/run/nginx.pid
  start program = "/etc/init.d/nginx start"
  stop program  = "/etc/init.d/nginx stop"

check process WAFastCGIAdaptor_gem9001 with pidfile /opt/gemstone/product/seaside/data/WAFastCGIAdaptor_server-9001.pid
  start program = "/opt/gemstone/product/seaside/bin/startSeasideGems30 9001" as uid seasideuser
  stop program = "/opt/gemstone/product/seaside/bin/stopSeasideGems30 9001" as uid seasideuser
  group seasideuser

check process maintenance_gem with pidfile /opt/gemstone/product/seaside/data/maintenance_gem.pid
  start program = "/opt/gemstone/product/seaside/bin/startMaintenanceGem30" as uid seasideuser
  stop program = "/opt/gemstone/product/seaside/bin/stopMaintenanceGem30" as uid seasideuser
  group seasideuser

check process service_gem with pidfile /opt/gemstone/product/seaside/data/service.pid
  start program = "/opt/gemstone/product/seaside/bin/startServiceGem30" as uid seasideuser
  stop program = "/opt/gemstone/product/seaside/bin/stopServiceGem30" as uid seasideuser
  group seasideuser
```

restart:
```bash
$ sudo /etc/init.d/monit restart
```


###Running on Ubuntu
Configuration file: 
```bash
sudo vim /etc/monit/monitrc
```

first need to edit:
`sudo vim /etc/default/monit`
and then set the line so that `startup` is set to `1`:
```
startup=1`
```

Check the syntax (only on Ubuntu):
```bash
$ sudo /etc/init.d/monit syntax
```

###Monit log
####AWS Linux
In the default `/etc/monit.conf` on AWS Linux there's a line:
```
include /etc/monit.d/*
```

By default this pulls in `/etc/monit.d/logging` which includes the line:
```
set logfile /var/log/monit.log
```

####Ubuntu
I've added the line:
```
set logfile /var/log/monit.log
```
to `/etc/monit/monitrc`

####Debugging tips
* Be aware that scripts called from Monit don't contain the same environment variables as the shell

####Re-enabling after disable
```bash
sudo chkconfig --levels 235 monit on
```

####Links
* [Monit examples](http://mmonit.com/wiki/Monit/ConfigurationExamples)
* [Monit documentation](http://mmonit.com/monit/documentation/monit.html)
* [Debugging Monit](http://stackoverflow.com/questions/3356476/debugging-monit)
* [Intalling Monit on Centos](http://www.lifelinux.com/how-to-install-monit-on-centos-redhat/)
