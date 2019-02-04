# Dokuwiki Docker image build

Build of [DokuWiki](https://www.dokuwiki.org/dokuwiki) for Docker.

Runs DokuWiki with **php7-fpm** and **ngingx**.

Runs **only** on HTTPS, by default using a self-signed certificate for `localhost`.

# Pull and run

```bash
docker run -d -p 443:443 natemago/dokuwiki:latest
```

Then access https://localhost/install.php to install and run setup of DokuWiki.

Once installed, the wiki will be available on https://localhost/doku.php

## Mount data directory

To persist the data between restarts you must mount a volume. The data directory is set to `/usr/share/nginx/html/data` (in the default document root for nginx on Debian).

DokuWiki keeps the user and configuration data in special directory `/usr/share/nginx/html/data`. You need to mount this as a persistent volume as well to keep the user logins and configuration data between logins as well.

To run the wiki with persistent local data dir:

```bash
docker run -d \
           -p 443:443 \
           --volume /storage/path/data:/usr/share/nginx/html/data \
           --volume /storage/path/conf:/usr/share/nginx/html/conf \
           natemago/dokuwiki:latest
```

where:
  * `/storage/path/data` is the path to your local persistent data storage.
  * `/storage/path/conf` is the path to the storage that will keep the configuration for DokuWiki.

## Add valid (signed) certificates

Certificates are read from `/etc/ssl/live`. You need to provide two certificate files (certificate and key):
 * `/etc/ssl/live/server.crt` - the certificate file
 * `/etc/ssl/live/server.key` - the private key file

These certificates can be obtained from [Let's Encrypt](https://letsencrypt.org/), just be sure to rename (as `server.crt` and `server.key`) and mount the directory under `/etc/ssl/live`.

To run with custom certificates:

```bash
docker run -d \
           -p 443:443 \
           --volume /storage/path/data:/usr/share/nginx/html/data \
           --volume /storage/path/conf:/usr/share/nginx/html/conf \
           --volume /certificates/path:/etc/ssl/live \
           natemago/dokuwiki:latest
```

# Building the Docker image

If you want to build the Docker image yourself:

```bash
# clone the repository first
git clone https://github.com/natemago/dokuwiki-docker.git
cd dokuwiki-docker

# build and tag
docker build -t natemago/dockuwiki:latest .
```
