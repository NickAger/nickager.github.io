---
tags: EC2, Cloud
title: "Create a reusable Amazon machine instance"
date: 2011-02-01
---

This post assumes you've *configured an EC2 instance>/blog/Installing-Gemstone-on-an-Amazon-EC2-Linux-instance* using Amazon's Linux AMI, or you've modified a *preconfigured instance>/blog/Create-a-free-Gemstone-server-in-the-cloud-in-10-minutes* and want to make that image reusable.

At the time of writing this post (December 2010), I *found>https://forums.aws.amazon.com/thread.jspa?threadID=56007&tstart=0* that I needed to update the *CloudInit package>https://help.ubuntu.com/community/CloudInit* to reinitialise it:

=sudo yum install cloud-init

then edit ==/etc/cloud/cloud.cfg== and change:
=user: ec2-user
to read:
=user: seasideuser

remove your SSH key from ==~/.ssh/==:
=rm -rf ~/.ssh
""Warning:"" Removing your SSH key will prevent you from being able to subsequently ssh into your remote image, however you'll be able to create a new image based on this image and pass in your SSH key.

reset the author initials within GemTools:
=Author reset

Stop Gemstone:
=sudo /etc/init.d/gemstone stop

and ==exit== the instance.

With the instance you want to reuse selected, choose ''Create Image'' from the Instance actions button:
{{{<div><img src="/blog-images/ec2fromscratch/CreateAnImageMenu.gif"></div>}}}

Give your image a name and a description:
{{{<div><img src="/blog-images/ec2fromscratch/AMIDialog.gif"></div>}}}

Which will create your own AMI (Amazon Machine Image): 
{{{<div><img src="/blog-images/ec2fromscratch/AMIList.gif"></div>}}}
The ''Permissions'' button allows you to make that image publicly visible:

{{{<div><img src="/blog-images/ec2fromscratch/RequestInstanceWizardCustom.gif"></div>}}}

which allows you to share and create as many instances of your image as you desire.
