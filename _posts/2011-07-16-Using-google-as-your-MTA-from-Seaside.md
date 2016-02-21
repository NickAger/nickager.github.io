---
title: "Using google as your MTA from Seaside"
date: 2011-07-16
layout: post
---
A quick post to show how we use Google mail to send mail from Seaside. Here's our setup for getitmade.com:

1) You need to add `WAEmailConfiguration` as a configuration ancestor.
And you need to add this configuration:

```Smalltalk
app configuration addParent: WAEmailConfiguration instance.
app 
		preferenceAt: #smtpServer put: 'localhost';
		preferenceAt: #smtpPort put: 259;
		preferenceAt: #smtpUsername put: 'support@getitmade.com';
		preferenceAt: #smtpPassword put: 'Rea11yS3cur3'.    "that isn't our password!"
```

2) You send mails with this string:

```Smalltalk
GRPlatform current
       seasideDeliverEmailMessage: ((WAEmailMessage
               from: (WAEmailAddress address: 'estebanlm@gmail.com')
                       to: (WAEmailAddress address:  'estebanlm@smallworks.com.ar')
                       subject: 'test')
               body: (WAStringEmailBody string: 'a test')).
```

it works inside the application (inside a session)... not outside (see below)

3) You need a [stunnel](https://www.stunnel.org/index.html) installed and running. In Ubuntu, you need to change:

a) replace stunnel.conf with:

```
client = yes
debug = debug

[smtps]
accept = 127.0.0.1:259
connect = smtp.gmail.com:465
```

b) create  /etc/stunnel/stunnel.pem

```
openssl req -new -x509 -days 3650 -nodes -out stunnel.pem -keyout stunnel.pem
```

c) enable running:

```
/etc/init.d/stunnel4
```
```
ENABLED=1
```

```
/etc/default/stunnel4
```
```
ENABLED=1
```

d) restart:

```
sudo /etc/init.d/stunnel4 restart
```

If you want to send the mail outside the session for example on a service task you need a mock request context then use something like:

```Smalltalk
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
