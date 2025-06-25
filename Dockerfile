FROM php:8.3-fpm

# Установка всех зависимостей
RUN apt-get update && apt-get install -y \
    nginx \
    mariadb-client \
    redis-tools \
    libreoffice \
    unoconv \
    libzip-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    zip \
    gd \
    opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Настройка LibreOffice
RUN mkdir -p /var/lib/libreoffice && \
    chown -R www-data:www-data /var/lib/libreoffice

# Настройка прав
RUN mkdir -p /var/lib/nginx /var/log/nginx \
    && chown -R www-data:www-data /var/lib/nginx /var/www \
    && chmod -R 775 /var/www \
    && touch /var/log/nginx/access.log /var/log/nginx/error.log \
    && chown www-data:www-data /var/log/nginx/*.log

# Копирование конфигов
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN if [ -f php.ini ]; then \
        cp php.ini /usr/local/etc/php/conf.d/custom.ini; \
    else \
        echo "Using default PHP configuration"; \
    fi

# Удаление дефолтного конфига Nginx
RUN rm -f /etc/nginx/sites-enabled/default

# Скрипт запуска
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Рабочая директория
WORKDIR /var/www/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

CMD ["/run.sh"]