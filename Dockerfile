#https://hub.docker.com/_/php
FROM php:7.2-fpm
MAINTAINER vitaliy ilinov <ilinov123@gmail.com>

#See makefile
ARG SOME_TEST=7.2
ENV SOME_TEST=${SOME_TEST}

# Install and enable xDebug
RUN pecl install xdebug \
&& docker-php-ext-enable xdebug

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    nano \
    zip \
    unzip \
    git \
    curl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user
RUN groupadd -g 1000 www \
&& useradd -u 1000 -ms /bin/bash -g www www

# Change current user to www
USER www
COPY /docker/after-build.sh /docker/after-build.sh
RUN bash /docker/after-build.sh

CMD ["php-fpm"]