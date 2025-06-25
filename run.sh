#!/bin/bash

# Запуск Apache
apache2ctl start

# Запуск Nginx (на переднем плане)
exec nginx -g "daemon off;"