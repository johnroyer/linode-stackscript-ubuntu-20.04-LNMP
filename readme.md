# Introduction

This is a Linode StackScript to create Ubuntu 20.04 with Nginx, PHP and MySQL.

It will takes about 5 minutes to finish deploy on Linode Nanode.

----

# PPAs

This script uses Ubuntu PPAs:

- `ppa:nginx/stable
- `ppa:ondrej/php`

You will get the latest release and bug fixed after deploy.


# PHP-fpm

Php-fom listen on `127.0.0.1:9000` on default. You can change the setting in the `config` folder.