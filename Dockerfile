
# Récupère l'image de php8.1 
FROM php:8.1 

# permet de récupéré toute les extensions necessaires pour symfony avec le symfony-cli
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | tee /etc/apt/sources.list.d/symfony-cli.list

# instalation de toute les extension necessaire pour executer du php 
RUN apt-get update \
    && apt-get install -y git libzip-dev libpng-dev libicu-dev symfony-cli \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl

# instalation de composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# modifie le repertoire courant (cd)   
WORKDIR /code