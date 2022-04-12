#https://hub.docker.com/_/php
FROM php:7.4-fpm

MAINTAINER vitaliy ilinov <ilinov123@gmail.com>

ARG UID
ARG GID

WORKDIR /var/www/html

# Install and enable additional extensions https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    autoconf \
    locales \
    bash \
    nano \
    make \
    git \
    default-mysql-client

# Install extensions by docker-php-ext-install.
RUN install-php-extensions @composer \
    gd \
    imagick \
    zip \
    opcache \
    memcached \
    xdebug \
    pdo_mysql \
    && mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

COPY ./ /docker

#Create user
RUN groupadd --gid $GID $UID && useradd --uid $UID --gid $GID -m $UID

#additional
RUN bash /docker/after-build.sh
