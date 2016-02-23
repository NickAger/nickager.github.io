---
title: "Understanding Nginx location matching and redirects"
tags: "Nginx, sysadmin"
date: 2011-03-08
layout: post
---

## Understanding location matching
There are three items to consider in-order to understand Nginx location matching:

* What does the location syntax match against?
* What is the matching precedence?
* At what stage does the match stop the location search.

**syntax:** 'location [=|~|~\*|^~|@] /uri/ { ... }'

### Regular expression matching
The "~" "~\*" and "^~" are regular expression matches.

* "~" a case-sensitive regular expression match.
* "~\*" a case-insensitive regular expression match.
* "^~" a case-sensitive regular expression match, but halts any other location matching once a match is made.

Note: Try not to confuse "^~" with "^regex". In the later case "^" is a regular expression operator meaning - match from the start-of-string. For example "^regex" matches against locations which begin with "regex".

### Location matching examples

```
location / {
    #matches everything - but is low priorty
}

location = /images {
    #literal match; matches a request for "/images" ONLY.
    #also halts the location scanning as soon as such an exact match is met.
    #exact text only, no regular expressions
}

location ^~ /images {
    #The "^~" results in a case sensitive regular expression match.
    #This means /images, /images/logo.gif, etc will all be matched.
    #Halts the location scanning as soon as a match is met.
}

location ~ /images {
    #As above except doesn’t stop searching for a more exact location clauses.
}

location ~* /images {
    #As above but case insensitive version
}


location ~ \.(gif|jpg|jpeg)$ {
    #Note ALL literal strings get checked first, and THEN regular expressions,
    #regular expressions are matched in the order they appear in the file.
}
```

Notes:

* the `location` syntax only matches against the address part of the URL; I have not found a way to match based on URL parameters.
* Nginx includes an `if` directive, but read [If is evil](http://wiki.nginx.org/IfIsEvil) before you use it.

## Understanding redirects

### External redirects
```
#Sends an HTTP 301 permanent redirection
location /getitmade {
    rewrite ^/getitmade(.*)$ $1 permanent;
}

#Sends an HTTP 302 temporary redirection
location /getitmade {
    rewrite ^/getitmade(.*)$ $1 redirect;
}

# matches only on an exact request to '/browse'
# can issues an HTTP 301 permanent redirect to http://$host
location = /browse {
     rewrite ^ http://$host permanent;
}
```

### Internal redirects
```
#The "break" syntax causes the rewrite processing to stop
location /admin {
     rewrite ^/admin/(.*)$ /$1 break;
}

#The "last" syntax causes Nginx to return to scanning location entries
#as above but now with the rewritten URL
location /admin {
     rewrite ^/admin/(.*)$ /$1 last;
}
```

See also the `alias` [directive](http://wiki.nginx.org/HttpCoreModule), though I've yet to use it successfully.

References:

* [Nginx offical documentation](http://wiki.nginx.org/HttpCoreModule)
* [How to debug location matching in Nginx](http://www.nginx-discovery.com/2011/04/day-46-how-to-debug-location-in-nginx.html)
* [Nginx location regexp or no regexp](http://www.nginx-discovery.com/2011/04/day-45-location-regexp-or-no-regexp.html)
* [Good introduction to location matching and redirecting](http://blog.rackcorp.com/?p=31)
* [General introduction to nginx syntax](http://library.linode.com/web-servers/nginx/configuration/basic)
* [General nginx syntax examples](https://calomel.org/nginx.html)
