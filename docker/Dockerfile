#https://hub.docker.com/_/php
FROM php:7.4-fpm
MAINTAINER vitaliy ilinov <ilinov123@gmail.com>

WORKDIR /var/www

# Install and enable additional extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

## Install extensions by docker-php-ext-install.
RUN install-php-extensions pdo_mysql \
    gd \
    imagick \
    zip \
    xdebug

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    nano \
    zip \
    unzip \
    autoconf \
    make \
    wget \
#    npm \
    curl

## Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./ /docker

#additional
RUN bash /docker/after-build.sh
