FROM centos:7

RUN yum -y install epel-release && \
    yum -y install https://repo.ius.io/ius-release-el7.rpm && \
    yum -y install gcc httpd mod_ssl mod_auth_kerb python-setuptools python-pip python36u-pip python36-devel \
            python36-mod_wsgi python36-m2crypto gmp-devel krb5-devel git openssl-devel gridsite which libaio memcached \
            nmap-ncat gfal2-all gfal2-util gfal2-python3 fts-rest-cli xrootd-client multitail vim libxml2-devel \
            openssh-clients xmlsec1-devel xmlsec1-openssl-devel libtool-ltdl-devel && \
    curl -sSL https://downloads.mariadb.com/Connectors/c/connector-c-3.1.13/mariadb-connector-c-3.1.13-centos7-amd64.tar.gz | tar xzv && \
    alternatives --install /usr/bin/mariadb_config mariadb_config /mariadb-connector-c-3.1.13-centos7-amd64/bin/mariadb_config 1 && \
    alternatives --install /usr/lib64/libmariadb.so.3 libmariadb.so.3 /mariadb-connector-c-3.1.13-centos7-amd64/lib/mariadb/libmariadb.so.3 1 && \
    alternatives --install /usr/lib64/libmariadb.so libmariadb.so /mariadb-connector-c-3.1.13-centos7-amd64/lib/mariadb/libmariadb.so.3 1 && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN git clone https://github.com/rucio/rucio.git /tmp/rucio && rm -rf /tmp/rucio/.git

ENV RUCIOHOME=/opt/rucio
RUN mkdir -p $RUCIOHOME && \

WORKDIR $RUCIOHOME
RUN mkdir -p \
      bin \
      etc \
      lib/rucio \
      tools

RUN python3 -m pip install --no-cache --upgrade pip && \
    python3 -m pip install --no-cache --upgrade setuptools wheel && \
    rm -rf /usr/lib/python3.6/site-packages/ipaddress*  && \
    if [ -r /tmp/rucio/requirements.txt ]; then \
        python3 -m pip install --no-cache --upgrade -r /tmp/rucio/requirements.txt ; \
    else \
        python3 -m pip install --no-cache --upgrade -r /tmp/rucio/etc/pip-requires-client \
                -r /tmp/rucio/etc/pip-requires -r /tmp/rucio/etc/pip-requires-test psycopg2-binary ; \
    fi && \
    ln -s $RUCIOHOME/lib/rucio /usr/local/lib/python3.6/site-packages/rucio

RUN pip2 install requests 

COPY .pep8 .pep8
COPY .flake8 .flake8
COPY pylintrc etc/pylintrc
RUN cp -r /tmp/rucio/etc . && \
    cp -r /tmp/rucio/tools . && \
    mkdir /var/log/rucio /var/log/rucio/trace && \
    chmod -R 777 /var/log/rucio

COPY alembic.ini google-cloud-storage-test.json $RUCIOHOME/etc/

# Add Certs here
COPY certs/rucio_ca.key.pem /etc/grid-security/certificates/rucio_ca.key.pem
COPY certs/rucio_ca.pem /etc/grid-security/certificates/rucio_ca.pem

COPY 00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf
COPY httpd.conf /etc/httpd/conf/httpd.conf
COPY rucio.conf /etc/httpd/conf.d/rucio.conf
RUN mkdir /root/.ssh && \
    chmod 700 /root/.ssh && echo "Host ssh1" > /root/.ssh/config && \
    echo "IdentityFile /root/.ssh/ruciouser_sshkey" >> /root/.ssh/config

COPY certs/ssh/ruciouser_sshkey.pub /root/.ssh/ruciouser_sshkey.pub
COPY certs/ssh/ruciouser_sshkey /root/.ssh/ruciouser_sshkey
RUN chmod 777 /var/log/rucio/trace && \
    mkdir -p /etc/httpd && \
    echo "" > /etc/httpd/conf.d/ssl.conf && \
    echo "" > /etc/httpd/conf.d/autoindex.conf && \
    echo "" > /etc/httpd/conf.d/userdir.conf && \
    echo "" > /etc/httpd/conf.d/welcome.conf && \
    echo "" > /etc/httpd/conf.d/zgridsite.conf

COPY logshow restartweb run_daemons /usr/local/bin/

RUN rm -r /tmp/rucio && \
    chmod +x /usr/local/bin/logshow && \
    chmod +x /usr/local/bin/restartweb && \
    chmod +x /usr/local/bin/run_daemons && \
    ln -fs /usr/bin/python3 /usr/bin/python

ENV PATH $PATH:$RUCIOHOME/bin
RUN chmod 0600 /root/.ssh/ruciouser_sshkey && \
    chmod 0644 /root/.ssh/ruciouser_sshkey.pub

COPY startup.sh /usr/local/sbin/
CMD ["/usr/local/sbin/startup.sh"]
