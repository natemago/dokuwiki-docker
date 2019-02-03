#!/usr/bin/env bash

function ensure_dir() {
  dir_path="$1"
  ownership="$2"
  perm="$3"

  if [ ! -d "${dir_path}" ]; then
    mkdir -p "${dir_path}"
  fi

  # ensure ownership
  if [ ! -z "${ownership}" ]; then
    chown "${ownership}" -R "${dir_path}"
  fi

  # ensure permissions
  if [ ! -z "${perm}" ]; then
    chmod "${perm}" -R "${dir_path}"
  fi
}

DOCROOT="/usr/share/nginx/html"
DATA_DIRS=( "pages" "attic" "meta" "media" "media_attic" "media_meta" "cache" "index" "locks")

for data_dir in "${DATA_DIRS[@]}"
do
  ensure_dir "${DOCROOT}/data/${data_dir}"
done

ensure_dir "${DOCROOT}/data" "www-data:www-data" "0700"
ensure_dir "${DOCROOT}/conf" "www-data:www-data" "0700"
ensure_dir "${DOCROOT}/inc" "www-data:www-data" "0700"


# Run PHP
if [ ! -d /run/php ]; then
    mkdir /run/php
fi
php-fpm7.0 --daemonize -c /etc/php/7.0/fpm/php.ini

echo "Running nginx"

# Run nginx
nginx -g "daemon off;"
