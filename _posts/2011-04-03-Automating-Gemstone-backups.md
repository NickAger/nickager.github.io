---
title: "Automating Gemstone backups"
date: 2011-04-03
tags: [Gemstone, Seaside]
layout: post
---
To create daily backups of your database:

```
sudo vim /etc/cron.daily/backupgemstone
```

enter the following script into the editor:

```
#!/bin/sh

/opt/gemstone/product/seaside/bin/runBackup
cp /opt/gemstone/product/seaside/data/backups/extent0.dbf \
 /home/seasideuser/backups/extent-`date +"%Y%m%d"`.dbf
 ```

Then the `backups` directory:

```
mkdir ~/backups
```

You can change the frequency of the backups by creating the backup-script in one of: `/etc/cron.monthly`,  `/etc/cron.weekly/`, `/etc/cron.daily/`,  `/etc/cron.hourly`
