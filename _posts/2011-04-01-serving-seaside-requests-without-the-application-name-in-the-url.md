---
title: "Serving Seaside requests without the application name in the URL"
date: 2011-04-01
tags: [DevOps, Nginx, Seaside]
layout: post
---
With fresh [Seaside image](http://seaside.st/download/pharo), try browsing to [http://localhost:8080](http://localhost:8080). You  should see the Seaside welcome screen. That's because `WAWelcome` is configured as the default application in `WAWelcome class>>#initialize`

```smalltalk
initialize
    | application |
    application := WAAdmin register: self asApplicationAt: 'welcome'.
    WAAdmin defaultDispatcher defaultName: 'welcome'.
```

However if you then click on say the `counter` example link within the welcome application, your url will change to something like:

    http://localhost:8080/welcome?_s=dbAXvectnvDJyAzD&_k=SzcZKEV2emBCuhbb

How can you remove `/welcome` from the subsequent urls? It's easily achieved by editing the configuration and setting the ""Server Path"" to '/'. The screen below is a grab of the Seaside configuration application showing how the "Server Path" is set - browse to http://localhost:8080/config.

<img src="/images/blog/serving-apps-from-root/serverPath.png" width="640" height="582" />

or programmatically:

```smalltalk
| application |
application := WAAdmin register: WAWelcome asApplicationAt: 'welcome'.
application preferenceAt: #serverPath put: '/'.
```

click around the welcome screen and you should find that all links generated by Seaside have replaced `/welcome` with '`/`'.

Job done ... well not quite. The story is more complicated if your application contains RESTful urls...

### Removing the application name from RESTful urls
The above method works perfectly until you start using RESTful urls in your application. Say the `welcome` application was modified to include RESTful urls using Philippe's [SeasideRest](http://code.google.com/p/seaside/wiki/SeasideRest) package, so that the counter sample could be accessed through `/welcome/counter` (though, given the focus of this article, you'd like it to be accessed through `/counter`). As another example, this blog, or any application based on [Pier](http://piercms.com), also contain RESTful urls. When the default Seaside dispatcher is faced with `/counter`, it will look for a registered application named `counter` which will result in:

```
/counter not found
```

...not surprising, as there's no `/counter` application registered:

![](/images/blog/serving-apps-from-root/browse.png)


What's going on here? We've fixed the outgoing links but the dispatcher needs some help looking up the incoming links. One solution for deployed applications, is to ask your front-end server to rewrite incoming urls. The [seaside book](http://book.seaside.com) describes how to [configure Apache](http://book.seaside.st/book/advanced/deployment/deployment-apache/configure-apache) so that incoming urls are rewritten to prepend the url with the application name before passing the request onto Seaside. However I've chosen the [Nginx](http://wiki.nginx.org) web-server in preference to Apache. Here's an Ningx configuration that I use in conjunction with the FastCGI server within Gemstone for rewriting incoming urls:

```
location / {
    include /etc/nginx/fastcgi_params;

    fastcgi_param  SCRIPT_NAME /appname$fastcgi_script_name;
    fastcgi_param  REQUEST_URI /appname$request_uri;
    fastcgi_param  DOCUMENT_URI /appname$document_uri;

    fastcgi_intercept_errors on;
    fastcgi_pass seaside;        
}
```

where `/appname` is substituted for the registered dispatcher name eg `/welcome`

**Note**: I tried the following Nginx rewrite configuration, but it didn't work as `REQUEST_URI` wasn't rewritten:

```
# didn't work for me
rewrite ^/(.*)$ /appname/$1 break;
```

A downside of this approach is that all requests will be prepended with `/appname`, including file requests. Worse still, file requests will be sent to Seaside, rather than handled directly by Nginx. I worked around this problem by ensuring that all static files I wanted to serve were in known directories and then I added those directories to my configuration. Such as:

```
location /files {

}
```

This location directive results in Nginx looking on the file system for all urls that match `/files`, see [Understanding Nginx Location Matching](/blog/understanding-nginx-location-matching/).

This worked, however there are alternatives that simplify your Nginx configuration and I think, result in a more flexible, maintainable configuration.

**Note:** [Norbert Hartl](http://norbert.hartl.name/) suggested an alternative approach after I published this post - see below

### Alternative #1: Dumb dispatcher
TODO: diagram of the server -> serveradapter -> RequestHandler -> WADispatcher default

What if the dispatcher simply forwarded all responses onto the default application, so that all path lookup is performed by the application, not the dispatcher.  One immediate problem is that `/files` and `/config` will not be available. On a deployed system this shouldn't be a problem as `/files` will normally be handled by the front end webserver. You can export all files from a `WAFileLibrary` derived library using:

```smalltalk
WAWelcomeFiles deployFiles
```

Create a dumb dispatcher by deriving from `WADispatcher` and overriding the following method:

```smalltalk
handleFiltered: aRequestContext
	self handleDefault: aRequestContext
```

Then install your dispatcher as the default dispatcher:

```smalltalk
WADispatcher default: NADispatcher new.
```

Finally register your application and set it as the default application:

```smalltalk
| application |
application := WAAdmin register: self asApplicationAt: 'welcome'.
WAAdmin defaultDispatcher defaultName: 'welcome'.
```

### Alternative #2: Skip the dispatcher altogether
TODO: Show how the WAServerAdaptor and the WAApplication and WADispatcher share lots of functionality in common.

Why bother with a dispatcher? You can register your application in place of the dispatcher:

```smalltalk
| application |
application := WAApplication new.
WAAdmin configureNewApplication: application.
application preferenceAt: #rootClass put: WAWelcome.
WADispatcher default: application
```

You can revert to the default dispatcher configuration with:

```smalltalk
WADispatcher default: WADispatcher new.
WAEnvironment reloadApplications.
```

When dispatching directly from an application the Nginx configuration can be simplified dramatically. The Nginx `try_files` directive first looks on the file system for a match. If the file isn't found Nginx will pass the request onto Seaside. For good measure I add another directive to ensure that Nginx doesn't trouble Seaside with requests for missing files. Here is the snippet of my Nginx configuration relating to static file serving:

```
server {
    listen 80;
    root /var/www;

    location / {
        try_files $uri @seaside;
    }

    # ensure that files are searched for locally and not passed to
    # Seaside if the file isn't found on the disk
    location ~* \.(gif|jpg|jpeg|png|css|html|htm|js|zip)$ {

    }
    .
    .
    .
```

**Note:** [Julian Fitzell](http://forum.world.st/Deploying-Seaside-on-a-Swazoo-Server-td3569506.html) has suggested an alternative approach (which was intentionally designed into Seaside) in which the application is set directly in the server adaptor:

```smalltalk
aServerAdaptor requestHandler: myApplication
```

> When `#requestHandler` is `nil` (the default state) it uses the default dispatcher.

Clearly this is a much neater approach than setting `WADispatcher default: myApplication` although it achieves the same result but in a round-about fashion. I choose the `WADispatcher default: myApplication` approach as it meant that in Gemstone I didn't have to change the scripts that start the multiple backend servers. In practice, though, it probably would have been better to adopt the intentional design rather than my more hackish approach.

### Exporting from file libraries #2
Here's a code-snippet, showing how I export files from the file libraries I require (as using the approaches I've outlined `/files` will no longer dispatch files from the file libraries):

```smalltalk
(WAFileLibrary allSubclasses select: [:each |
    each name beginsWithAnyOf: #('WA'  'PR' 'JQ')])
    do: [:each |
        Transcript show: 'writing file Libarary: "', each asString, '"'; cr.
        each deployFiles]
```

### Norberts comments

> I struggled a few hours not hitting the exact configuration. And now I cannot remember why it didn't work. My case is working right now.  I think for the files and config case there is a solution that might help

```
      location ~ ^/(?!files|config) {
         set $appname "/myapp";
         try_files $uri @default;
      }

      location /config {
         set $appname "";
         try_files $uri @default;
      }

      location /files {
         set $appname "";
         try_files $uri @default;
      }


      location @default {
         include /etc/nginx/fastcgi_params;

         fastcgi_param  SCRIPT_NAME $appname$fastcgi_script_name;
         fastcgi_param  REQUEST_URI $appname$request_uri;
         fastcgi_param  DOCUMENT_URI $appname$document_uri;

         fastcgi_intercept_errors on;
         fastcgi_pass seaside;
      }
```

> The first location prevents (by using negative lookahead) matching the special cases. The individual cases paramterize the resulting dispatch by utilizing a variable. This way you could dispatch to multiple seaside applications without having to copy the section all the time.

> You refer to a rewrite rule using break. I read today that break not only breaks out of the rewriting but also does not rewrite the url. Probably that is the problem you encountered.
