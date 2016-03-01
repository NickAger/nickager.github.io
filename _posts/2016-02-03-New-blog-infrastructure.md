---
layout: post
title: "Configuring Jekyll"
date: 2016-02-03
tags: [Jekyll, blog]
excerpt_separator: <!--more-->
---

Adopting Jekyll I wanted:
# Low or no maintenance blog
# Github to be able to generate the site for me.

The second item means no Jekyll plug-ins unless there are supported by Github.

- talk about the problem of errors, setting up Travis etc

# Getting the basics working

A useful introduction - http://jmcglone.com/guides/github-pages/

https://github.com/jekyll/jekyll  http://jekyllrb.com
Jekyll includes Smalltalk code highlighting so my existing posts have come across. The only thing I miss is the ability to embed 'live' components within the blog eg my file upload component.

Its great not having to host the site myself with all the energy that takes and its free.

<!--more-->

I was inspired by the octopress theme used by http://norbert.hartl.name

When you go to jekyll http://jekyllrb.com the quick start guide shows:

```bash
~ $ gem install jekyll
~ $ jekyll new my-awesome-site
~ $ cd my-awesome-site
~/my-awesome-site $ jekyll serve
# => Now browse to http://localhost:4000
```

resulted in subtly different parsing and errors when I discovered when github mailed-me with an unspecific `Page build failure` with no indication of the error.
From https://jekyllrb.com/docs/github-pages/

> Our friends at GitHub have provided the github-pages gem which is used to manage Jekyll and its dependencies on GitHub Pages. Using it in your projects means that when you deploy your site to GitHub Pages, you will not be caught by unexpected differences between various versions of the gems. To use the currently-deployed version of the gem in your project, add the following to your

Instead I created a `Gemfile` in the root folder of my site as:

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

had to specify a version of Ruby, I went with 2.1.8, which is closed to the version installed on my Mac.  So my `.travis.yml` ends up as:

```yml
language: ruby
script: "bundle exec jekyll build"
rvm:
  - 2.1.8
```

to my `_config.yml` file, I added the line:

```
exclude: [vendor] # for travis
```

which again is apparently

# Customisations

My archive page I wanted to highlight the years so I added:

{% comment %}raw formatting idea from http://stackoverflow.com/questions/3426182/how-to-escape-liquid-template-tags {% endcomment %}
```liquid
{% raw %}{% for post in site.posts %}
  {% assign currentdate = post.date | date: "%Y" %}
  {% if currentdate != date %}
    {% unless forloop.first %}</ul>{% endunless %}
    <h2 id="y{{post.date | date: "%Y"}}">{{ currentdate }}</h2>
    <ul>
    {% assign date = currentdate %}
  {% endif %}
	<li><span>{{ post.date | date: "%B %d" }}</span> » <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a></li>
  {% if forloop.last %}</ul>{% endif %}
{% endfor %}{% endraw %}
```

from [Stack overflow: "Jekyll/Liquid Templating: How to group blog posts by year?"](http://stackoverflow.com/questions/19086284/jekyll-liquid-templating-how-to-group-blog-posts-by-year)

## Other customistations
* [Adding an Edit Link to Github Pages in Jekyll](http://webcache.googleusercontent.com/search?q=cache:3TA-ApJ1xqAJ:rgardler.github.io/2015/07/26/add-edit-me-link-for-github-pages/+&cd=3&hl=en&ct=clnk&gl=us&client=safari)
* [Adding next/previous blog posts links ](http://david.elbe.me/jekyll/2015/06/20/how-to-link-to-next-and-previous-post-with-jekyll.html)
* The raw site file are on [github](https://github.com/NickAger/nickager.github.io)
* [How to use Github issues for comments](http://ivanzuzak.info/2011/02/18/github-hosted-comments-for-github-hosted-blogs.html)
* Introduction to Jekyll and deatils of how to use github commenting in your blog http://loyc.net/2014/blogging-on-github.html
* [Post excerpts](https://jekyllrb.com/docs/posts/#post-excerpts)
* [How to list your Jekyll posts by tag](http://www.jokecamp.com/blog/listing-jekyll-posts-by-tag/)
* [Sitemaps for GitHub Pages](https://help.github.com/articles/sitemaps-for-github-pages/)

![](/images/blog/new-blog-infrastructure/unhelpfulgithubmessage.png)

![](/images/blog/new-blog-infrastructure/travis-error-mail.png)

![](/images/blog/new-blog-infrastructure/travis-error-screen.png)
