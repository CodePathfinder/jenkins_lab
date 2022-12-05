FROM php:8.0-apache

COPY . /var/www/html/

RUN sed -i 's/localhost/db/g' /var/www/html/db.php

# install php extention to connect php apache to mysql
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get upgrade -y
