FROM node:9.3 as node

FROM php:7.2-apache
MAINTAINER Damien PIQUET <dpiquet@teicee.com>

# Copy nodejs from node image
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /opt/yarn /opt/yarn
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin /usr/local/bin

# Custom Vhost
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN set -xe \
    #
    # Install PHP dependencies
    #
    && apt-get update \
    && apt-get install -y git subversion openssh-client coreutils unzip libpq-dev nano \
    && apt-get install -y autoconf build-essential libpq-dev binutils-gold libgcc1 linux-headers-amd64 make python libpng-dev libjpeg-dev libc-dev libfreetype6-dev libmcrypt-dev libicu-dev sqlite3-pcre libxml2-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    #
    # Install Xdebug
    #
    && pecl install xdebug-2.6.0 \
    && pecl list-files xdebug |grep src |cut -d ' ' -f 3 > /usr/local/etc/php/conf.d/xdebug.ini \
    #
    # PHP Configuration
    #
    && docker-php-ext-install -j$(nproc) iconv mbstring intl pdo_pgsql pdo_mysql gd zip bcmath soap sockets \
    && docker-php-source delete \
    && echo "Installing composer" \
    #
    # Install composer
    #
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer \
    #
    # Install webpack-encore
    #
    && npm install -g @symfony/webpack-encore \
    #
    # Enable httpd mod_rewrite, mod_headers, mod_expires
    #
    && a2enmod rewrite headers expires\
    #
    # Build dependencies cleanup
    #
    && apt-get remove -y autoconf gcc g++ libpq-dev linux-headers-amd64 make libmcrypt-dev libicu-dev libpq-dev libxml2-dev build-essential \
    && apt-get clean

EXPOSE 80
