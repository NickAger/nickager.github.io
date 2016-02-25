---
layout: post
title: "Configuring Jekyll"
date: 2016-02-03
---

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
