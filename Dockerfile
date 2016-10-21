FROM php:7.0
MAINTAINER Alex + Martin

ENV DEBIAN_FRONTEND noninteractive

# do the basic OS upgrades - PHP official image is based on Debian
# ----------------------------------------------------------------
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
	apt-utils
	
# install gosu
# ------------
ENV GOSU_VERSION 1.9
RUN set -x \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true 

# install libraries and prerequisites for PHP module builds
# ---------------------------------------------------------  
RUN apt-get install -y --no-install-recommends \
    git \
    libbz2-dev \
    libicu-dev \
    libmcrypt-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libvpx-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev
	
# set the locale
# --------------
RUN export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

# set the timezone
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# use the helper scripts from the official PHP container
# to build some more modules
# ------------------------------------------------------
RUN docker-php-ext-install \
	bz2 \
	gd \
	mcrypt \
	zip \
	intl \
	pdo_mysql \
	opcache

# install php
# RUN apt-get install -y --force-yes \
#      php7.0-cli \
#      php7.0-dev \
#      php-pgsql \
#      php-sqlite3  \
#      php-gd  \
#      php-apcu \
#      php-curl \
#      php7.0-mcrypt \
#      php-imap \
#      php-mysql \
#      php-memcached \
#      php7.0-readline \
#      php-xdebug php-mbstring \
#      php-xml \
#      php7.0-zip \
#      php7.0-intl \
#      php7.0-bcmath \
#      php-soap 

RUN sed -i -e "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini && \
    sed -i -e "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

RUN find /etc/php/7.0/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

RUN mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php

# install composer
# ----------------
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc 

# install laravel envoy
RUN composer global require "laravel/envoy"

# install laravel installer
RUN composer global require "laravel/installer"

# install lumen installer
RUN composer global require "laravel/lumen-installer"

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs && \
    /usr/bin/npm install -g gulp && \
    /usr/bin/npm install -g bower

COPY container-content/init.sh  /
COPY container-content/entry.sh /
COPY container-content/add-user-and-su.sh /
COPY container-content/ostype.sh /

WORKDIR "/app"
CMD ["/entry.sh"]

