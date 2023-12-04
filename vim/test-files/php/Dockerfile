FROM php:8.2.0-apache-bullseye

RUN pecl install xdebug-3.2.1 \
	&& docker-php-ext-enable xdebug

COPY xdebug.ini $PHP_INI_DIR/conf.d/99-xdebug.ini
