---
layout: post
title: "New blogging platform"
date: 2016-02-03
---
When you are the person who uses the software most you become the maintainer. When the community is small. YoU end up building a lot of the infrastructure yourself.
Smalltalk has much to recommend it, but recently I've become parallel/concurrent future I need to in

https://github.com/jekyll/jekyll  http://jekyllrb.com
Jekyll includes Smalltalk code highlighting so my existing posts have come across. The only thing I miss is the ability to embed 'live' components within the blog eg my file upload component.

Its great not having to host the site myself with all the energy that takes and its free.

When you go to jekyll http://jekyllrb.com the quick start guide shows:

```bash
~ $ gem install jekyll
~ $ jekyll new my-awesome-site
~ $ cd my-awesome-site
~/my-awesome-site $ jekyll serve
# => Now browse to http://localhost:4000
```

resulted in subtly different parsing and errors when I discovered when github mailed-me with an unspecific `Page build failure` with no indication of the error. Instead I created a `Gemfile` in the root folder of my site as:

```
source 'https://rubygems.org'
gem 'github-pages'
```

and installed using:

```
bundle install
```

then built using:


```
bundle exec jekyll build --safe
```

all this is documented on the github pages [Setting up your Pages site locally with Jekyll](https://help.github.com/articles/setting-up-your-pages-site-locally-with-jekyll/)

Note rather than having to setup a local instance of jekyll you can use travis to report build errors - https://help.github.com/articles/viewing-jekyll-build-error-messages/