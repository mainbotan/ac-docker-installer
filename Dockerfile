FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    nginx \
    mariadb-client \
    redis-tools \
    libzip-dev \
    libpng-dev \
    libfreetype6-dev \
    && docker-php-ext-install \
    pdo_mysql \
    zip \
    gd \
    && a2enmod rewrite

# Настройка Apache на порт 8080
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf

# Права для Nginx и Apache
RUN mkdir -p /var/lib/nginx && \
    chown -R www-data:www-data /var/lib/nginx /var/www && \
    chmod -R 775 /var/www

# Копируем конфиги
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 80 8080

CMD ["/run.sh"]