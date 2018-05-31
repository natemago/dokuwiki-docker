#FROM nginx:1.13
FROM debian:stretch

RUN apt update && \
    apt install -y php7.0-fpm

RUN apt install -y nginx-full
RUN apt install -y wget
RUN apt install -y php-xml

COPY nginx.conf /etc/nginx/nginx.conf
COPY dokuwiki.conf /etc/nginx/conf.d/default.conf
COPY php.ini       /etc/php/7.0/fpm/php.ini

RUN echo '<?php phpinfo(); ?>' > /usr/share/nginx/html/index.php

RUN echo 'catch_workers_output = yes' >> /etc/php/7.0/fpm/pool.d/www.conf
RUN echo 'php_flag[display_errors] = on' >> /etc/php/7.0/fpm/pool.d/www.conf
RUN echo 'php_admin_flag[log_errors] = on' >> /etc/php/7.0/fpm/pool.d/www.conf
RUN echo 'php_flag[display_startup_errors] = on' >> /etc/php/7.0/fpm/pool.d/www.conf

USER root
COPY nginx_php_fpm.sh /nginx_php_fpm.sh
RUN chmod +x /nginx_php_fpm.sh

# Dokuwiki setup

RUN wget "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz" -O dokuwiki.tgz && \
    tar xvf dokuwiki.tgz && \
    mv dokuwiki-2018-04-22a/* /usr/share/nginx/html/

#ADD data-real/pages /usr/share/nginx/html/data/pages

#RUN ls /usr/share/nginx/html/data
RUN mkdir -p /usr/share/nginx/html/data/pages
RUN chown www-data:www-data -R /usr/share/nginx/html/data && \
    chown www-data:www-data -R /usr/share/nginx/html/conf && \
    chown www-data:www-data -R /usr/share/nginx/html/inc
RUN chmod 0700 -R /usr/share/nginx/html/data
RUN chmod 0700 -R /usr/share/nginx/html/conf
RUN chmod 0700 -R /usr/share/nginx/html/inc

CMD "/nginx_php_fpm.sh"
