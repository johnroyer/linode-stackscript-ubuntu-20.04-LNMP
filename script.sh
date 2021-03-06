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
wget https://raw.githubusercontent.com/johnroyer/linode-stackscript-ubuntu-20.04-LNMP/master/config/nginx-default -O /root/nginx-default
wget https://raw.githubusercontent.com/johnroyer/linode-stackscript-ubuntu-20.04-LNMP/master/config/www.conf -O /root/www.conf
wget https://raw.githubusercontent.com/johnroyer/linode-stackscript-ubuntu-20.04-LNMP/master/index.php -O /root/index.php
cd /root


# Nginx
apt-get install -y nginx-full
cp /root/nginx-default /etc/nginx/sites-available/default
systemctl restart nginx.service

# PHP
apt-get install -y \
    php8.0-cli php8.0-fpm \
    php8.0-bcmath php8.0-bz2 php8.0-curl php8.0-enchant php8.0-gd \
    php8.0-imagick php8.0-intl php8.0-mbstring php8.0-mcrypt php8.0-memcached \
    php8.0-mysql php8.0-readline php8.0-redis php8.0-sqlite3 \
    php8.0-xml php8.0-xsl php8.0-zip 
cp /root/www.conf /etc/php/8.0/fpm/pool.d/
cp /root/index.php /var/www/html/
systemctl restart php8.0-fpm.service

# MySQL
wget https://dev.mysql.com/get/mysql-apt-config_0.8.20-1_all.deb -O /root/mysql.deb
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-codename select trusty'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-preview select '
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select '
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/unsupported-platform select abort'
dpkg -i /root/mysql.deb
apt-get update
apt-get install -y mysql-server-8.0 mysql-client-8.0
usermod -d /var/lib/mysql/ mysql
mysqld --initialize --user=mysql
systemctl start mysql.service
