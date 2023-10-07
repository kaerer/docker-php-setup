#- https://stackoverflow.com/questions/44447821/how-to-create-a-docker-image-for-php-and-node

FROM node:14 AS node
FROM php:8.1-fpm as app

#- copy node and npm
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
#- test node and npm
RUN node -v
RUN npm -v

RUN apt-get update
RUN apt-get install -y libzip-dev g++ gcc autoconf tar git libicu-dev mlocate curl wget lsof zip unzip libxml2 \
    libfreetype-dev libjpeg62-turbo-dev libpng-dev libonig-dev libxml2-dev libpq-dev \
    zlib1g-dev libz-dev libmemcached-dev libssl-dev memcached libmemcached-tools
RUN pecl install memcached && \
    docker-php-ext-enable memcached
RUN pecl install apcu && \
    docker-php-ext-enable apcu
RUN docker-php-ext-configure zip && \
    docker-php-ext-install zip

RUN docker-php-ext-install intl opcache pdo pdo_mysql mysqli mbstring simplexml sockets bcmath dom exif fileinfo gd iconv
RUN docker-php-ext-enable intl opcache pdo pdo_mysql mysqli mbstring simplexml sockets bcmath dom exif fileinfo gd iconv

## Useful PHP extension installer image, copy binary into your container
#COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
#
## APK stands for Alpine Linux package keeper (manager). One can use the apk command to delete, install, upgrade, or list software
## An access control list (ACL) contains rules that grant or deny access to certain digital environments.
## Description: FASTCgi (fcgi) is a language independent, high performant extension to CGI. https://archlinux.org/packages/extra/x86_64/fcgi/
## The file command is used to determine the type of a file
## The gettext program translates a natural language message into the user's language
#RUN apk add --no-cache \
#		acl \
#        bash \
#        fcgi \
#		file \
#		gettext \
#		git \
#	;
#
## https://docs.moodle.org/311/en/admin/environment/php_extension/intl
## https://www.educba.com/php-zip-files/
## The APCu extension adds object caching functions to PHP.
## OPcache is a type of caching system that saves precompiled script bytecode in a server’s memory called a cache, so each time a user visits a web page, it loads faster.
#RUN set -eux; \
#    install-php-extensions \
#    	intl \
#    	zip \
#    	apcu \
#		opcache \
#        pdo pdo_mysql \
#    ;

WORKDIR /var/www/project

#- Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer -v

#- Symfony Cli
#RUN curl -sS https://get.symfony.com/cli/installer | bash
#RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Dev image
# This stage is meant to be target-built into a separate image
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target
FROM app as app_dev

# Xdebug has different modes / functionalities. We can default to 'off' and set to 'debug'
# when we run docker compose up if we need it
ENV XDEBUG_MODE=off

# Copy xdebug config file into container
COPY ./php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Install xdebug
RUN pecl install xdebug
#RUN docker-php-ext-install xdebug
#RUN set -eux; \
#	install-php-extensions xdebug
