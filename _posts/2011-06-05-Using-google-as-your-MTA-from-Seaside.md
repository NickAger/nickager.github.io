---
title: "Using google as your MTA from Seaside"
date: 2011-06-05
tags: [DevOps, MTA, Seaside]
layout: post
---
A quick post to show how we use Google mail to send mail from Seaside. Here's our setup for getitmade.com:

1) You need to add `WAEmailConfiguration` as a configuration ancestor.
And you need to add this configuration:

```smalltalk
app configuration addParent: WAEmailConfiguration instance.
app
		preferenceAt: #smtpServer put: 'localhost';
		preferenceAt: #smtpPort put: 259;
		preferenceAt: #smtpUsername put: 'support@getitmade.com';
		preferenceAt: #smtpPassword put: 'Rea11yS3cur3'.    "that isn't our password!"
```

2) You send mails with this string:

```smalltalk
GRPlatform current
       seasideDeliverEmailMessage: ((WAEmailMessage
               from: (WAEmailAddress address: 'support@getitmade.com')
                       to: (WAEmailAddress address:  'a.client@astartup.com')
                       subject: 'test')
               body: (WAStringEmailBody string: 'a test')).
```

it works inside the application (inside a session)... not outside (see below)

3) You need [stunnel](https://www.stunnel.org/index.html) installed and running. In Ubuntu, you need to make the following changes:

a) replace stunnel.conf with:

```
client = yes
debug = debug

[smtps]
accept = 127.0.0.1:259
connect = smtp.gmail.com:465
```

b) create  /etc/stunnel/stunnel.pem

```bash
$ openssl req -new -x509 -days 3650 -nodes -out stunnel.pem -keyout stunnel.pem
```

c) enable running:

```bash
$ vim /etc/init.d/stunnel4
```

```
ENABLED=1
```

```bash
$ vim /etc/default/stunnel4
```

```
ENABLED=1
```

d) restart:

```
sudo /etc/init.d/stunnel4 restart
```



---



If you want to send the mail outside the session for example on a service task you need a mock request context then use something like:

```smalltalk
WACurrentRequestContext
		use: IZMockCurrentRequestContext
		during: [
			GRPlatform current
       			seasideDeliverEmailMessage: ((WAEmailMessage
               			from: (WAEmailAddress address: 'support@getitmade.com')
                       		to: (WAEmailAddress address:  toEmailAddress)
                       subject: aSubject)
               body: (WAStringEmailBody string: aBody)) ]
```
