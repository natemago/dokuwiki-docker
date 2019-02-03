if [ ! -d /run/php ]; then
    mkdir /run/php
fi
php-fpm7.0 --daemonize -c /etc/php/7.0/fpm/php.ini

nginx -g "daemon off;"
