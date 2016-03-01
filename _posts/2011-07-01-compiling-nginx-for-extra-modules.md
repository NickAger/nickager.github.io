---
title: "Compiling Nginx to add extra modules"
tag: [DevOps, Nginx, devops]
date: 2011-07-01 07:03:00 +0000
layout: post
---
This post describes the process of compiling Nginx on Ubuntu 10.04.1 (Server Edition) and Amazon EC2 Linux (which is based on Centos 5.5). The motivation for compiling Nginx, was to add the following modules:

* [upload progress module](http://wiki.nginx.org/NginxHttpUploadProgressModule).
* [upload module](http://www.grid.net.ru/nginx/upload.en.html).
* [upstream fair module](http://wiki.nginx.org/HttpUpstreamFairModule).

All modules are compiled into the one Nginx binary; there is currently no concept of loadable binary modules. The Nginx package defined in the Ubuntu or Centos repositories comes with a fairly comprehensive set of [built-in modules](http://wiki.nginx.org/Modules). There is also a set of [third party modules](http://wiki.nginx.org/3rdPartyModules) available.  To add a third party module you need to recompile Nginx source and include the module.

Note: I am far from a Linux expert, especially when it comes to building packages from source. I'd love to hear alternative approaches.

### Setting your machine up for building
Firstly set your machine up for building code and install the default Nginx installation. Firstly on Ubuntu:

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install nginx
sudo apt-get install build-essential
sudo apt-get install libssl-dev libpcre3-dev zlib1g-dev unzip
```

on Centos (eg EC2 Linux machine):

```bash
sudo yum update
sudo yum install nginx
sudo yum groupinstall "Development Tools"
sudo yum install openssl-devel pcre pcre-devel zlib-devel
```


### Installing Nginx source
Grab the latest Nginx source from [nginx.org](http://nginx.org/). At the time of writing the latest source was version 0.8.54:

```
wget http://nginx.org/download/nginx-0.8.54.tar.gz
```

You might also like to (optionally) grab the repositories source. For Ubuntu:

```
apt-get source nginx
```

On EC2:

```
$yum list | grep nginx
nginx.x86_64                              0.7.67-1.0.amzn1             @amzn
$
$ get_reference_source -p nginx
Please enter your AWS account id: 4930-xxxx-xxxx

Requested package: nginx

Found package from local RPM database: nginx-0.7.67-1.0.amzn1
Corresponding source RPM to found package : nginx-0.7.67-1.0.amzn1.src.rpm

Your AWS account id: 4930-xxxx-xxxx

Are these parameters correct? Please type 'yes' to continue: yes
Source RPM for 'nginx-0.7.67-1.0.amzn1' downloaded to: /usr/src/srpm/debug/nginx-0.7.67-1.0.amzn1.src.rpm
$ mkdir nginx-0.7.67-1.0
$ cd nginx-0.7.67-1.0/
$ rpm2cpio /usr/src/srpm/debug/nginx-0.7.67-1.0.amzn1.src.rpm | cpio -idmv --no-absolute-filenames
$ tar -zxvf nginx-0.7.67.tar.gz
```

One benefit of downloading the packaged source is that you can see the configuration options used when compiling the source. The files to study are:

* Ubuntu: `nginx-0.7.65/debian/rules`
* EC2:  `nginx.spec`

### Downloading the upload progress module
Download the [Nginx upload progress module](http://wiki.nginx.org/NginxHttpUploadProgressModule). at the time of writing the latest version was 0.8.2 and can be downloaded from github [here](https://github.com/masterzen/nginx-upload-progress-module/archives/v0.8.2)

> nginx_uploadprogress_module is an implementation of an upload progress system, that monitors RFC1867 POST upload as they are transmitted to upstream servers.
>
> It works by tracking the uploads proxied by Nginx to upstream servers without analysing the uploaded content and offers a web API to report upload progress in Javascript, JSON or configurable format. It works because Nginx acts as an accelerator of an upstream server, storing uploaded POST content on disk, before transmitting it to the upstream server. Each individual POST upload request should contain a progress unique identifier.

```
wget --no-check-certificate https://github.com/masterzen/nginx-upload-progress-module/zipball/v0.8.2
mv v0.8.2 nginx-upload-progress-module-v0.8.2.zip
```

### Downloading the upload module
I also incorporated the [upload module](http://www.grid.net.ru/nginx/upload.en.html), which can be downloaded from [here](http://www.grid.net.ru/nginx/download/), at the time of writing the latest version was 2.2.0

> The module parses request body storing all files being uploaded to a directory specified by upload_store directive. The files are then being stripped from body and altered request is then passed to a location specified by upload_pass directive, thus allowing arbitrary handling of uploaded files. Each of file fields are being replaced by a set of fields specified by upload_set_form_field directive. The content of each uploaded file then could be read from a file specified by $upload_tmp_path variable or the file could be simply moved to ultimate destination. Removal of output files is controlled by directive upload_cleanup.

```
wget http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.zip
```

### Downloading the upstream fair module
The [upstream fair module](http://wiki.nginx.org/HttpUpstreamFairModule), source's git repository is [here](https://github.com/gnosek/nginx-upstream-fair)

> The upstream_fair module sends an incoming request to the least-busy backend server, rather than distributing requests round-robin.

```
wget --no-check-certificate https://github.com/gnosek/nginx-upstream-fair/zipball/master
mv master nginx-upstream-fair.zip
```

### Preparing the build directory

```
ls
nginx-0.8.54.tar.gz
nginx_upload_module-2.2.0.zip
nginx-upload-progress-module-v0.8.2.zip
nginx-upstream-fair.zip
```

decompress:

```
unzip nginx-upload-progress-module-v0.8.2.zip
unzip nginx_upload_module-2.2.0.zip
unzip nginx-upstream-fair.zip
tar -zxvf nginx-0.8.54.tar.gz
```

resulting in:

```
gnosek-nginx-upstream-fair-2131c73
masterzen-nginx-upload-progress-module-8b55a34
nginx_upload_module-2.2.0
nginx-0.8.54
```

### Configuration options for the compile
As I mentioned above you can see the packaged source configuration options in the files:

* Ubuntu:`ginx-0.7.65/debian/rules`
* EC2:  `nginx.spec`

However I found that you can examine the compile options used to build the repository binary by typing:

```
nginx -V
```

My version of Nginx on Ubuntu had a date of Mar 5 2010 and a file size of: 657800

```
/usr/sbin/nginx -V
nginx version: nginx/0.7.65
TLS SNI support enabled
configure arguments: --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/body --http-proxy-temp-path=/var/lib/nginx/proxy --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --with-debug --with-http_stub_status_module --with-http_flv_module --with-http_ssl_module --with-http_dav_module --with-http_gzip_static_module --with-http_realip_module --with-mail --with-mail_ssl_module --with-ipv6 --add-module=/build/buildd/nginx-0.7.65/modules/nginx-upstream-fair
```

and:

```
file /usr/sbin/nginx
/usr/sbin/nginx: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.15, stripped
```

Examining Nginx in EC2 which is dated Oct 20 2010, size 658736:

```
$ sudo /usr/sbin/nginx -V
nginx version: nginx/0.7.67
built by gcc 4.1.2 20080704 (Red Hat 4.1.2-48)
TLS SNI support enabled
configure arguments: --user=nginx --group=nginx --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --pid-path=/var/run/nginx.pid --lock-path=/var/lock/subsys/nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_perl_module --with-mail --with-mail_ssl_module --with-ipv6 --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic'
```

and:

```
$ file /usr/sbin/nginx
/usr/sbin/nginx: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped<
```

The default Ubuntu and EC2 configuration are different. The EC2 configuration doesn't include:
* `--with-debug`
    it's really useful to compile with debugging enabled to help understand the behaviour of location matching and rewriting in your Nginx configuration. Debugging a configuration is then enabled with a [parameter in the config file](http://nginx.org/en/docs/debugging_log.html).

However EC2 adds the following over Ubuntu:

* `--with-http_addition_module` [HttpAdditionModule](http://wiki.nginx.org/HttpAdditionModule)
* `--with-http_sub_module` [HttpSubModule](http://wiki.nginx.org/HttpSubModule)
* `--with-http_random_index_module` [HttpRandomIndexModule](http://wiki.nginx.org/HttpRandomIndexModule)
* `--with-http_secure_link_module` [HttpSecureLinkModule](http://wiki.nginx.org/HttpSecureLinkModule)
* `--with-http_perl_module` [EmbeddedPerlModule](http://wiki.nginx.org/EmbeddedPerlModule)

The EC2 binary was also compiled with some additional compiler flags which looked useful:
`-with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic'`

There is also a comprehensive list of [compile options](http://wiki.nginx.org/InstallOptions) on the Nginx site.

### Compiling

Combining the best of both configurations, including the modules I thought I'd need and adding the three 3rd-party modules I set out to include, can be built in the following way:

```
cd nginx-0.8.54/
CFLAGS+=-O2 \
./configure --conf-path=/etc/nginx/nginx.conf \
--with-cpu-opt=amd64 \
--error-log-path=/var/log/nginx/error.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-scgi-temp-path=/var/lib/nginx/scgi_temp \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi_temp \
--with-debug \
--with-http_stub_status_module \
--with-http_flv_module \
--with-http_ssl_module \
--with-http_dav_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-mail \
--with-mail_ssl_module \
--with-ipv6 \
--add-module=../gnosek-nginx-upstream-fair-2131c73 \
--add-module=../nginx_upload_module-2.2.0 \
--add-module=../masterzen-nginx-upload-progress-module-8b55a34 \
--with-cc-opt='-pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic'

make
strip objs/nginx
ls -hl objs/nginx
-rwxr-xr-x 1 seasideuser seasideuser 737K 2011-01-26 20:07 objs/nginx
```

copy the resultant executable:

```
sudo cp objs/nginx /usr/sbin/
```

and you're done - that is except editing your configuration file - but I'll save that for another post

#### Compilation problems

You may see some compile warnings:

```
objs/src/os/unix/ngx_process.o: In function `ngx_signal_handler':
ngx_process.c:(.text+0x347): warning: `sys_errlist' is deprecated; use `strerror' or `strerror_r' instead
ngx_process.c:(.text+0x33a): warning: `sys_nerr' is deprecated; use `strerror' or `strerror_r' instead
```

according to the nginx wiki this is [normal](http://nginx.org/en/docs/sys_errlist.html) and  they can be ignored.


### References

* Nginx [compile options](http://wiki.nginx.org/InstallOptions).
* [built-in modules](http://wiki.nginx.org/Modules).
* [third party modules](http://wiki.nginx.org/3rdPartyModules).
* [upload progress and upload modules](http://blog.martinfjordvald.com/2010/08/file-uploading-with-php-and-nginx/).
* [Nginx journey of discovery blog](http://www.nginx-discovery.com/)
