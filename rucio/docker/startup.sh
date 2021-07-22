#!/bin/bash

# make certs
# user certs
openssl req -new -newkey rsa:2048 -nodes -keyout $RUCIOHOME/etc/userkey.pem -subj "/CN=Rucio User" > $RUCIOHOME/etc/ruciouser.csr
openssl x509 -req -days 9999 -CAcreateserial -extfile <(printf "keyUsage=critical") -in $RUCIOHOME/etc/ruciouser.csr -CA /etc/grid-security/certificates/rucio_ca.pem -CAkey /etc/grid-security/certificates/rucio_ca.key.pem -out $RUCIOHOME/etc/usercert.pem
cp $RUCIOHOME/etc/usercert.pem  $RUCIOHOME/etc/usercertkey.pem
cat $RUCIOHOME/etc/userkey.pem >> $RUCIOHOME/etc/usercertkey.pem

chmod 0400 $RUCIOHOME/etc/userkey.pem && mkdir /root/.ssh && \
chmod 700 /root/.ssh && echo "Host ssh1" > /root/.ssh/config && \
echo "IdentityFile /root/.ssh/ruciouser_sshkey" >> /root/.ssh/config

# rucio host certs
openssl req -new -newkey rsa:2048 -nodes -keyout /etc/grid-security/hostkey.pem -subj "/CN=rucio" > /etc/grid-security/hostcert_rucio.csr
openssl x509 -req -days 9999 -CAcreateserial -extfile <(printf "subjectAltName=IP:$OSG_FQDN,DNS:localhost") -in /etc/grid-security/hostcert_rucio.csr -CA /etc/grid-security/certificates/rucio_ca.pem -CAkey /etc/grid-security/certificates/rucio_ca.key.pem -out /etc/grid-security/hostcert.pem -passin pass:123456
chmod 0400 /etc/grid-security/hostkey.pem

cp /etc/grid-security/certificates/rucio_ca.pem /etc/grid-security/certificates/5fca1cb1.0

# startup httpd
httpd -D FOREGROUND
