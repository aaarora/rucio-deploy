#!/bin/bash

# make certs with right DNS
openssl req -new -newkey rsa:2048 -nodes -keyout /etc/grid-security/hostkey.pem -subj "/CN=$OSG_FQDN" > /etc/grid-security/hostcert_fts.csr
openssl x509 -req -days 9999 -CAcreateserial -extfile <(printf "subjectAltName=DNS:$OSG_FQDN,DNS:localhost") -in /etc/grid-security/hostcert_fts.csr -CA /etc/grid-security/certificates/rucio_ca.pem -CAkey /etc/grid-security/certificates/rucio_ca.key.pem -out /etc/grid-security/hostcert.pem -passin pass:123456
mv /etc/grid-security/certificates/rucio_ca.pem /etc/grid-security/certificates/5fca1cb1.0
chmod 400 /etc/grid-security/hostkey.pem

# wait for MySQL readiness
/usr/local/bin/wait-for-it.sh -h $DB_ADDR -p 3306 -t 3600

# initialise / upgrade the database
/usr/share/fts/fts-database-upgrade.py <<< y

# fix Apache configuration
/usr/bin/sed -i 's/Listen 80/#Listen 80/g' /etc/httpd/conf/httpd.conf

# startup the FTS services
/usr/sbin/fts_server               # main FTS server daemonizes
/usr/sbin/httpd -DFOREGROUND       # FTS REST frontend & FTSMON
