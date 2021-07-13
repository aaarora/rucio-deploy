#!/bin/bash

# initialise / upgrade the database
/usr/share/fts/fts-database-upgrade.py <<< y

/usr/bin/sed -i 's/Listen 80/#Listen 80/g' /etc/httpd/conf/httpd.conf

# startup the FTS services
/usr/sbin/fts_server               # main FTS server daemonizes
/usr/sbin/httpd -DFOREGROUND       # FTS REST frontend & FTSMON
