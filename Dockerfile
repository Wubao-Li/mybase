FROM centos:7.2.1511

ENV GO_VERSION=1.7 \
    NODEJS_VERSION=v6.4.0 \
    DJANGO_VERSION=1.10 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    GOPATH=/go \
    PATH=/usr/local/go/bin:/go/bin:$PATH

RUN yum -y update \
    && yum -y install epel-release gcc g++ make git mercurial tar mariadb-devel mysql-devel mariadb libffi-devel openssl-devel unzip wget curl iproute bind-utils \
    && localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
    && rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum -y install python-pip supervisor libevent-devel python-backports-lzma \
# Change working dir to /tmp
    && cd /tmp \
# Installing node.js
    && curl -O https://nodejs.org/dist/$NODEJS_VERSION/node-$NODEJS_VERSION-linux-x64.tar.gz \
    && tar --strip-components 1 -xzf node-$NODEJS_VERSION-linux-x64.tar.gz -C /usr/local \
# Installing Golang
    && curl -OL https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz \
    && tar -zxf go$GO_VERSION.linux-amd64.tar.gz -C /usr/local \
    && mkdir -p /go/src /go/bin /go/pkg \
# Installing Python
    && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
    && yum -y update \
    && yum -y install python35u python35u-libs python35u-devel python35u-pip \
# Clean installed and downloaded packages
    && yum -y clean all \
    && rm -rf /tmp/*
    
# Installing Djaong
RUN pip3.5 install mysqlclient redis gunicorn django=="$DJANGO_VERSION"

CMD ["python3.5"]
