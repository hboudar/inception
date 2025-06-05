#!/bin/bash
set -e

# Wait for MariaDB to be ready
until mysqladmin ping -h "$DB_HOST" --silent; do
  echo "Waiting for MariaDB to start..."
  sleep 2
done

cd /var/www/html

# Install WP-CLI if not already installed
if ! command -v wp >/dev/null 2>&1; then
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

# Download WordPress core (skip if already downloaded)
if [ ! -f wp-config.php ]; then
  DB_PASS=$(cat /run/secrets/db_pass)
  ADMIN_PASS=$(cat /run/secrets/admin_pass)
  USER_PASS=$(cat /run/secrets/user_pass)
  
  wp core download --allow-root
  wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="$DB_HOST" --allow-root
  wp core install --url="$DOMAIN" --title="$TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL" --allow-root
  wp user create "$USER_NAME" "$USER_EMAIL" --role=author --user_pass="$USER_PASS" --allow-root
fi

chmod -R 777 /var/www/html/

# Start PHP-FPM in foreground
php-fpm7.4 -F
