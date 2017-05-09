FROM ubuntu:latest

MAINTAINER Onur Genc <onurgenc@gmail.com>


RUN apt-get update \
  && apt-get install -y \
        git \
        cron \
        libfreetype6-dev \
        libicu-dev \
        libmcrypt-dev \
        libxslt1-dev \
        libjpeg-dev \
        libcurl3 \
        curl \
        nano

RUN apt-get install -y \
        nginx \
        php7.0-fpm \
        php7.0-mcrypt \
        php7.0-zip \
        php7.0-curl \
        php7.0-cli \
        php7.0-mysql \
        php7.0-gd \
        php7.0-xsl \
        php7.0-json \
        php7.0-intl \
        php-pear \
        php7.0-dev \
        php7.0-common \
        php7.0-mbstring \
        php-soap

CMD mkdir -p /run/php && \
    chown -R www-data:www-data /run/php

COPY ./default.conf /etc/nginx/conf.d/
COPY ./nginx.conf /etc/nginx/

COPY ./magento.ini /usr/local/etc/php/conf.d/

CMD service nginx restart


### Composer install and auth
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY ./auth.json /root/.composer/

### Crontab
COPY ./crontab /
RUN crontab -u www-data /crontab
RUN cron


ADD ./entrypoint.sh /
