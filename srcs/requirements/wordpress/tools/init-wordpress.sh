#!/bin/bash

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root
wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --allow-root
wp core install --url=$DOMAIN --title=$TITLE --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASS --admin_email=$ADMIN_EMAIL --allow-root
wp user create $USER_NAME $USER_EMAIL --role=author --user_pass=$USER_PASS --allow-root

wp plugin install redis-cache --allow-root
wp plugin activate redis-cache --allow-root

wp config set WP_REDIS_HOST 'redis' --allow-root
wp config set WP_CACHE 'true' --allow-root
wp config set FS_METHOD 'direct' --allow-root
wp config set WP_REDIS_PORT '6379' --allow-root
wp redis enable --allow-root

chmod -R 777 /var/www/html/

php-fpm7.4 -F