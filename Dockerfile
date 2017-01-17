FROM php:7.0
MAINTAINER Alexander von Renteln <alexander.renteln@gmail.com>, Martin Bayreuther

ENV DEBIAN_FRONTEND noninteractive

# Set locale and timezone
# ------------------------
RUN apt-get update \
 && apt-get install -y locales \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && dpkg-reconfigure locales \
 && ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
 && rm -rf /var/lib/apt/lists/*
ENV LC_ALL en_US.UTF-8
ENV LANG   en_US.UTF-8


# Do basic OS upgrades - PHP official image is based on Debian
# ----------------------------------------------------------------
RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        bzr \
        curl \
        ca-certificates \
        git \
        lsb-release \
        mercurial \
        openssh-client \
        procps \
        subversion \
        wget \
  && rm -rf /var/lib/apt/lists/*

# Add repo for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# For node.js
# FROM buildpack-deps:jessie
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        bzip2 \
        file \
        g++ \
        gcc \
        imagemagick \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libdb-dev \
        libevent-dev \
        libffi-dev \
        libgdbm-dev \
        libgeoip-dev \
        libglib2.0-dev \
        libjpeg-dev \
        libkrb5-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libmysqlclient-dev \
        libncurses-dev \
        libpng-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libwebp-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        make \
        patch \
        xz-utils \
        yarn \
        zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN groupadd -r node && useradd -r -g node node

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 7.0.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN npm install -g gulp \
 && npm install -g bower \
 && npm install -g npm-check-updates

# instead of apt-get install yarn can also be installed via npm:
# && npm install -g yarn \


# Install gosu
# ------------
ENV GOSU_VERSION 1.9
RUN set -x \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true 


# Install forego
# --------------
RUN wget -O /usr/local/bin/forego "https://github.com/jwilder/forego/releases/download/v0.16.1/forego" \
 && chmod +x /usr/local/bin/forego



# Install libraries and prerequisites for PHP module builds
# ---------------------------------------------------------  
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git \
        libbz2-dev \
        libicu-dev \
        libmcrypt-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libvpx-dev \
        libjpeg-dev \
        libpng-dev \
        libxml2-dev \
        libxpm-dev \
  && rm -rf /var/lib/apt/lists/*


# Use the helper scripts from the official PHP container
# to build some more modules
# ------------------------------------------------------
RUN docker-php-ext-install \
  bz2 \
  gd \
  mcrypt \
  zip \
  intl \
  pdo_mysql \
  opcache \
  soap

# install php
# RUN apt-get install -y --force-yes \
#      php-pgsql \
#      php-apcu \
#      php-imap \
#      php-memcached \
#      php-xdebug \
#      php7.0-bcmath \



RUN mkdir -p /run/php/ \
 && chown -Rf www-data.www-data /run/php

# install composer
# ----------------
RUN curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer \
 && printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc 

# install laravel envoy
RUN composer global require "laravel/envoy"

# install laravel installer
RUN composer global require "laravel/installer"

# install lumen installer
RUN composer global require "laravel/lumen-installer"


# Add php-unit
RUN mkdir -p /opt/phpunit \
 && curl -L -sS https://phar.phpunit.de/phpunit.phar -o /usr/local/bin/phpunit \
 && chmod +x /usr/local/bin/phpunit
# alternative: 
# RUN composer global require "phpunit/phpunit=5.5.*"

COPY container_content/php.ini  /usr/local/etc/php/php.ini

COPY container_content/entry.sh       /entry.sh
COPY container_content/init.sh        /init.sh
COPY container_content/Procfile       /Procfile
COPY container_content/run_tests.sh   /run_tests.sh

COPY container_content/become.sh      /root/become.sh
COPY container_content/ostype.sh      /root/ostype.sh

RUN chmod +x /*.sh \
 && chmod +x /root/*.sh


EXPOSE 8000
WORKDIR "/app"
CMD ["/entry.sh"]

