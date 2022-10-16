FROM php:7.4-alpine

RUN apk --no-cache add curl nodejs make autoconf libpng libpng-dev mysql-client libzip-dev &&\
    docker-php-ext-configure gd && \
    NPROC=$(getconf _NPROCESSORS_ONLN || 1) && \
    docker-php-ext-install -j${NPROC} gd pdo_mysql mysqli opcache zip bcmath && \
    apk del --no-cache libpng-dev && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=1.10.20

ADD . /var/www/hasaki-api

WORKDIR /var/www/hasaki-api

RUN cd /var/www/hasaki-api && COMPOSER_MEMORY_LIMIT=-1 composer install

RUN chmod +x artisan

RUN composer dump-autoload --optimize

EXPOSE 8022

CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/hasaki-api/public"]