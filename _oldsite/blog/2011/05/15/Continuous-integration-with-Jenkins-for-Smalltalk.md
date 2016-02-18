---
title: "Continuous Integration With Jenkins for Smalltalk"
tags: "sysadmin CI Smalltalk"
date: 2011-05-15
---
###Installing Jenkins
The Jenkins project provides clear installation instructions for [Jenkins on Ubunutu](http://pkg.jenkins-ci.org/debian/). The main details are:

1) Install Jenkins with `apt-get` by adding the Jenkins repository to your system, First add the key:
```
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
```
2) Then add the following entry in your `/etc/apt/sources.list`:
```
deb http://pkg.jenkins-ci.org/debian binary/
```
3) Update your local package index, then finally install Jenkins:
```
sudo apt-get update
sudo apt-get install jenkins
```
4) By default Jenkins is started on `http://localhost:8080`, see `/etc/init.d/jenkins` 

####Setting up Jenkins for Smalltalk Continuous Integration
Lukas Renggli has integrated Jenkins and Smalltalk using a set of shell scripts and `*.st` files.  Lukas's [git Jenkins repository](https://github.com/renggli/builder) contains a detailed `README` which provides excellent instructions. For most people Lukas's instructions will suffice. However for sysadmin challenged developers such as myself the following description of how I setup Jenkins for Smalltalk CI may be of use.  

I installed Lukas's builder scripts within the Jenkins home folder as user Jenkins:
```
sudo su - jenkins
git clone git://github.com/renggli/builder.git
```

As per Lukas's instructions you need to ensure that the `builder` folder is on the path for the Jenkins server. I achieved this by creating a file `/etc/profile.d/jenkins.sh` containing:
```
export PATH="$PATH:/var/lib/jenkins/builder"
```

Then restart the Jenkins server so it picks up the new path:
```
sudo /etc/init.d/jenkins restart
```

Install the latest stable version of the Pharo image:
```
cd ~/builder/images
wget http://www.pharo-project.org/pharo-download/stable/
unzip Pharo-1.2.1-11.04.03.zip
mv Pharo-1.2.1-11.04.03/* .
rm Pharo-1.2.1-11.04.03 -fr
rm Pharo-1.2.1-11.04.03.zip
```

Move `PharoV10.sources` to the sources folder:
```
mv PharoV10.sources ../sources/
```

Download a VM (here I'm downloading latest Cog VM, at the time of writing r2382):
```
cd
wget http://www.mirandabanda.org/files/Cog/VM/VM.r2382/coglinux.tgz
tar zxvf coglinux.tgz
```

I installed Jenkins on a 64bit version of Ubuntu server 10.04.1; to run the VM I needed to install the 32bit support libraries:
```
sudo apt-get install ia32-libs
```

Examine `~/builder/build.sh` and notice that it contains a line:
```
PHARO_VM="cog"
```
rather than editing `~/builder/build.sh` and changing `PHARO_VM` to point to your VM, I chose to create a batch file called `~/builder/cog`, which contains:

```
#! /bin/bash
/var/lib/jenkins/coglinux/squeak "$@"
```

and made it executable:
```
chmod +x cog
```

Follow Lukas's directions in his `README` for configuring Smalltalk builds through Jenkins Web UI, including adding Jenkins plugins; Checkstyle, Emma and "URL Change Trigger". I set up a test Seaside build with the following command line entered into the `execute shell` Jenkins web configuration:
```
build.sh -i Pharo-1.2.1 -o seaside3 -s seaside3 -s testrunner -s seaside3-tests
```

Select your build project through the Jenkins web ui and select the "Build Now" option. If the build isn't successful, select the build in the "Build History" and examine the "Console Output" to search for reasons for the failure. 

###Debugging your configuration
Viewing the console output is invaluable for debugging your setup. I added `echo $PATH` and other `echo` output to the `execute shell` web text box help during debugging.
