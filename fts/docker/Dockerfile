FROM opensciencegrid/software-base:fresh

# Install FTS
RUN yum install -y epel-release.noarch
RUN curl https://fts-repo.web.cern.ch/fts-repo/fts3-prod-el7.repo > /etc/yum.repos.d/fts3-prod-el7.repo
RUN curl https://dmc-repo.web.cern.ch/dmc-repo/dmc-el7.repo > /etc/yum.repos.d/dmc-el7.repo
RUN yum upgrade -y
RUN yum install -y mysql multitail gfal2-plugin* fts-server fts-client fts-rest fts-monitoring fts-mysql fts-msg
RUN yum clean all

COPY fts3rest.conf /etc/httpd/conf.d/fts3rest.conf
RUN echo "" > /etc/httpd/conf.d/ssl.conf &&\
    echo "" > /etc/httpd/conf.d/autoindex.conf &&\
    echo "" > /etc/httpd/conf.d/userdir.conf &&\
    echo "" > /etc/httpd/conf.d/welcome.conf &&\
    echo "" > /etc/httpd/conf.d/zgridsite.conf
