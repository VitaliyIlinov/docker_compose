#https://hub.docker.com/_/php
FROM php:7.4-fpm
MAINTAINER vitaliy ilinov <ilinov123@gmail.com>

ARG UID
ARG GID

WORKDIR /var/www

# Install and enable additional extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

## https://github.com/mlocati/docker-php-extension-installer
## Install extensions by docker-php-ext-install.
RUN install-php-extensions @composer \
    gd \
    imagick \
    zip \
    xdebug \
    pdo_mysql

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
    git \
    npm \
    curl


COPY ./ /docker
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN usermod -u ${UID} www-data && groupmod -g ${GID} www-data

#additional
RUN bash /docker/after-build.sh
