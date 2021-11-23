#!/usr/bin/env bash

# apt init
cd /root/
apt-get update

# general tools
apt-get install -y \
    software-properties-common \
    net-tools openssh-client openssl \
    bzip2 gzip zip unzip \
    vim nano


# Add PPA
add-apt-repository ppa:nginx/stable -y
add-apt-repository ppa:ondrej/php -y
apt-get update


# default config
wget https://lab.zeroplex.tw/linode/config.zip -O /root/config.zip
cd /root
unzip config.zip


# Nginx
cp config/nginx/sites-available/default /etc/nginx/sites-available/default
systemctl restart nginx.service

# PHP
apt-get install -y \
    php8.0-cli php8.0-fpm \
    php8.0-bcmath php8.0-bz2 php8.0-curl php8.0-enchant php8.0-gd \
    php8.0-imagick php8.0-intl php8.0-mbstring php8.0-mcrypt php8.0-memcached \
    php8.0-mysql php8.0-readline php8.0-redis php8.0-sqlite3 \
    php8.0-xml php8.0-xsl php8.0-zip 
cp config/php/8.0/fpm/pool.d/www.conf /etc/php/8.0/fpm/pool.d/
systemctl restart php8.0-fpm.service

