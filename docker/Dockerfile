#https://hub.docker.com/_/php
FROM php:8.1-fpm

MAINTAINER vitaliy ilinov <ilinov123@gmail.com>

ARG UID
ARG GID

WORKDIR /var/www

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
    npm \
    curl \
    default-mysql-client

# Install extensions by docker-php-ext-install.
RUN install-php-extensions @composer \
    gd \
    imagick \
    zip \
    opcache \
    exif \
    memcached \
    xdebug \
    pdo_mysql \
    redis \
    && mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

ARG XDEBUG="off"
RUN if [[ "$XDEBUG" = "on" ]]; then pecl install xdebug && docker-php-ext-enable xdebug; fi

ENV COMPOSER_MEMORY_LIMIT -1

#Create user
RUN groupadd --gid $GID $UID && useradd --uid $UID --gid $GID -m $UID

#additional
COPY ./ /docker
RUN bash /docker/after-build.sh
