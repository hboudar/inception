#!/bin/bash

set -euo pipefail
trap 'echo "[ERROR] Script failed at line $LINENO"' ERR


echo "[INFO] Waiting for $DB_HOST..."
until mysqladmin ping -h "$DB_HOST" --silent; do
  sleep 2
done
echo "[INFO] MariaDB is available."

#root dir of wordpress(volume)
cd /var/www/html

# Install WP-CLI if not already installed
if ! command -v wp >/dev/null 2>&1; then
  echo "[INFO] Installing WP-CLI..."
  curl -sSLO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

DB_PASS=$(< /run/secrets/db_pass)
ADMIN_PASS=$(< /run/secrets/admin_pass)
USER_PASS=$(< /run/secrets/user_pass)

if [ ! -f wp-config.php ]; then
  echo "[INFO] Setting up WordPress..."
  wp core download --allow-root
  wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --allow-root \
    --skip-check

  wp core install \
    --url="$DOMAIN" \
    --title="$TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASS" \
    --admin_email="$ADMIN_EMAIL" \
    --allow-root

  wp user create \
    "$USER_NAME" "$USER_EMAIL" \
    --role=author \
    --user_pass="$USER_PASS" \
    --allow-root
else
  echo "[INFO] WordPress already set up."
fi

# Set secure permissions (avoid 777 unless explicitly required)
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Ensure PHP-FPM socket binding was patched
grep -q "listen = 0.0.0.0:9000" /etc/php/7.4/fpm/pool.d/www.conf || {
  echo "[INFO] Patching PHP-FPM config..."
  sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf
}

mkdir -p /run/php

echo "[INFO] Starting php-fpm..."
exec php-fpm7.4 -F