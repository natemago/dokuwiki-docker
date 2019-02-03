FROM debian:stretch

RUN apt update && \
    apt install -y nginx-full \
                   php7.0-fpm \
                   php-xml \
                   wget
# Generate self-signed certificate
RUN mkdir -p /etc/ssl/live
RUN openssl req \
              -x509 \
              -newkey rsa:4096 \
              -keyout /etc/ssl/live/server.key \
              -out /etc/ssl/live/server.crt \
              -days 365 \
              -nodes \
              -subj '/CN=localhost'

# Dokuwiki installation
RUN wget "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz" -O dokuwiki.tgz && \
   tar xvf dokuwiki.tgz --transform='s#^dokuwiki[^/]\+/\(.\+\)#dokuwiki/\1#' && \
   mv dokuwiki/* /usr/share/nginx/html/

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/dokuwiki.conf /etc/nginx/conf.d/default.conf
COPY php/php.ini       /etc/php/7.0/fpm/php.ini

USER root
COPY dokuwiki-entrypoint.sh /dokuwiki-entrypoint.sh
RUN chmod +x /dokuwiki-entrypoint.sh

CMD "/dokuwiki-entrypoint.sh"
