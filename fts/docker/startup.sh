#!/bin/bash

/usr/share/fts/fts-database-upgrade.py <<< y

/usr/bin/sed -i 's/Listen 80/#Listen 80/g' /etc/httpd/conf/httpd.conf

exec /usr/bin/supervisord -c /etc/supervisord.conf
