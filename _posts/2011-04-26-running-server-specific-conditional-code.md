---
title: "Running server specific conditional code"
date: 2011-04-26
tags: "sysadmin, Seaside, Gemstone"
layout: post
---
I'd like to be able to deploy the same code base to my live, staging, test, backup and development servers, however sometimes the code is server specific. For example, I only want my live server to go through the live payment gateway; my other servers should use the test payment gateway.

One solution would be to handle the differences in the package manager configuration (eg [Metacello](http://code.google.com/p/metacello/) configuration) and load different classes depending on the server. I take this approach for some of my code, but especially for the payment gateway I'd like a "belt and braces" approach where the server can query itself to ensure that it's using a class that's appropriate for the server.

The solution is two-pronged:

* First ensure the server can identify itself (sysadmin work :-( )
* Query the server and match the identity against an appropriate class, which encapsulates the differences in behaviour between the servers.


## Identifying the server
On my minimally configured servers `hostname` resulted in the following:

```
$ hostname
ip-10-234-189-50
```

The first task is to ensure `hostname` identifies the server in a useful form. Unfortunately Centos and Ubuntu (10.4) based servers handle this differently:

### Centos
Test to see if the server's hostname is correctly configured:

```
$ hostname
ip-10-234-189-50
```

In this case it isn't so let's config it:

```
$ sudo vim /etc/sysconfig/network
```

```
NETWORKING=yes
HOSTNAME=**getitmade.com**
.
.
.
```

```
$ sudo vim /etc/hosts
```
```
127.0.0.1   localhost localhost.localdomain **getitmade.com**
.
.
.
```


```
$ sudo hostname getitmade.com
$ sudo /etc/init.d/network restart
```

Testing the changes have worked:
```
$ hostname
getitmade.com
```

### Ubuntu
Test to see if the server's hostname is correctly configured:

```
$ hostname
ip-10-234-189-50
```

...not in this case; let's configure it:

```
$ sudo vim /etc/hostname
```

```
staging.getitmade.com
```

```
$ sudo vim /etc/hosts
```
```
127.0.0.1   localhost localhost.localdomain **staging.getitmade.com**
.
.
.
```

```
$ sudo hostname staging.getitmade.com
$ sudo /etc/init.d/network restart
$ sudo restart hostname
```

Testing the changes have worked:

```
$ hostname
staging.getitmade.com
```

## Resolving the class from the server
Now the servers are correctly configured, identifying the server from Smalltalk is trivially simple:

```smalltalk
NetNameResolver localHostName
```

I chose to wrap the call to `#localHostName` in a method which maps the server's hostname string to a symbol and caches the result:

```smalltalk
server
	^ server ifNil: [
		| servers |
		servers := Dictionary new
		 	at: 'getitmade.com' put: #live;
			at: 'staging.getitmade.com' put: #staging;
			at: 'testing.getitmade.com' put: #testing;
			at: 'backup.getitmade.com' put: #backup;
			yourself.
		server := servers at: self serverName ifAbsent: [ #development ] ]
```


I'm particular interested in whether the server is live or not, so I encapsulate this as:

```smalltalk
isLiveServer
	^ self server = #live
```

Finally I abstract the differences between the servers in a class hierarchy and use a factory in the base class to return an appropriate class for the server:

```smalltalk
merchantClass
	| serverIdentification |
	serverIdentification := IZServerIdentification default.
	self allSubclassesDo: [:aMerchantClass |
		(aMerchantClass designedFor: serverIdentification)
			ifTrue: [ ^ aMerchantClass ] ].

	^ nil
```


the `#designedFor:` method is implemented on the class which encapsulations the parameters for live server as:

```smalltalk
designedFor: serverIdentification
	^ serverIdentification isLiveServer
```


**Note:** `NetNameResolver>>#localHostName` on Pharo doesn't work reliably on Mac OSX. See this [message thread](http://lists.squeakfoundation.org/pipermail/squeak-dev/2010-March/146746.html) for the background to the issue. In my case, although I develop on a Mac, I deploy on Gemstone and Linux and so circumvent this problem. Also note `NetNameResolver>>#localHostName` on Gemstone is a thin wrapper around:

```smalltalk
GsSocket getLocalHostName
```
