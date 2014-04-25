# Pull base image.
FROM ubuntu:14.04

MAINTAINER Chengkun

RUN apt-get update

#Install jre, this is required by Selenium
RUN apt-get install -qqy openjdk-7-jdk

## Install Node.js  v0.10
RUN apt-get install -qqy nodejs
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
RUN curl https://www.npmjs.org/install.sh | sh

## Install firefox, copied from creack\firefox_VNC
RUN apt-get install -qqy xvfb firefox 

# Install rbenv and ruby 2.1 
RUN apt-get install -qqy git build-essential libssl-dev zlib1g-dev

RUN git clone https://github.com/sstephenson/rbenv.git /.rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git /.rbenv/plugins/ruby-build
ENV PATH /.rbenv/shims:/.rbenv/bin:$PATH

RUN CONFIGURE_OPTS="--disable-install-doc" rbenv install 2.1.0 && \
    rbenv global 2.1.0 

ENV PATH /.rbenv/shims:$PATH

RUN echo 'install: --no-rdoc --no-ri' >> ~/.gemrc && \
    echo 'update: --no-rdoc --no-ri' >> ~/.gemrc && \
    gem install bundler --no-rdoc --no-ri

## Install Mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

RUN apt-get update
RUN apt-get install -qqy mongodb-org

RUN service mongod start

## Removed unnecessary packages
RUN apt-get autoremove -y

## Clear package repository cache
RUN apt-get clean all

ENTRYPOINT /.rbenv/bin/rbenv init -
