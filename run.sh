#!/bin/bash

# Запуск LibreOffice в фоновом режиме
unoconv --listener &
soffice --headless --nologo --nofirststartwizard --accept="socket,host=127.0.0.1,port=2002;urp;" &

# Запуск PHP-FPM
php-fpm -D

# Ожидание готовности PHP-FPM
while ! nc -z localhost 9000; do
    sleep 1
done

# Проверка конфигурации Nginx
nginx -t

# Запуск Nginx
exec nginx -g "daemon off;"