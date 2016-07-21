FROM phusion/baseimage
MAINTAINER benlueis <blueyy168@hotmail.com>
ENV REFRESHED_AT 2016-07-10

###############################################################################
#                                INSTALLATION
###############################################################################

### install prerequisites (cURL, gosu)

ENV GOSU_VERSION 1.8

ARG DEBIAN_FRONTEND=noninteractive
RUN set -x \
 && apt-get update -qq \
 && apt-get install -qqy --no-install-recommends ca-certificates curl \
 && rm -rf /var/lib/apt/lists/* \
 && curl -L -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
 && curl -L -o /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
 && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
 && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true \
 && apt-get clean \
 && set +x


### install Elasticsearch
RUN apt-get update -qq \
 && apt-get install -qqy \
		openjdk-8-jdk \
 && apt-get clean

# Install Python Setuptools
RUN apt-get install -y python-setuptools
 
# Install pip
RUN easy_install pip
 
# Add and install Python modules
ADD requirements.txt /src/requirements.txt
RUN cd /src; pip install -r requirements.txt
 
# Bundle app source
ADD . /src

###############################################################################
#                                   START
###############################################################################

CMD [ "/bin/bash" ]
