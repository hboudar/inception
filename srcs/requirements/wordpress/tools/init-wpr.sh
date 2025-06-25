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

  # Redis plugin and config
  wp plugin install redis-cache --allow-root
  wp plugin activate redis-cache --allow-root

  wp config set WP_REDIS_HOST 'redis' --allow-root
  wp config set WP_REDIS_PORT '6379' --allow-root
  wp config set WP_CACHE 'true' --allow-root
  wp config set FS_METHOD 'direct' --allow-root

  wp redis enable --allow-root

  wp user create \
    "$USER_NAME" "$USER_EMAIL" \
    --role=author \
    --user_pass="$USER_PASS" \
    --allow-root
else
  echo "[INFO] WordPress already set up."
fi


# Ensure shared group exists
if ! getent group webgroup >/dev/null; then
  groupadd -g 1000 webgroup
fi

# Add www-data to shared group (idempotent)
if ! id -nG www-data | grep -qw webgroup; then
  usermod -aG webgroup www-data
fi

# IMPORTANT: Add FTP user to the same group (if FTP user exists)
if id ftpuser &>/dev/null; then
  if ! id -nG ftpuser | grep -qw webgroup; then
    usermod -aG webgroup ftpuser
  fi
fi

# Set ownership and group recursively to www-data:webgroup
chown -R www-data:webgroup /var/www/html

# Set directory permissions with setgid bit to maintain group inheritance
find /var/www/html -type d -exec chmod 2775 {} \;

# Set file permissions to group writable
find /var/www/html -type f -exec chmod 664 {} \;

# Patch PHP-FPM if needed
grep -q "listen = 0.0.0.0:9000" /etc/php/7.4/fpm/pool.d/www.conf || {
  echo "[INFO] Patching PHP-FPM config..."
  sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf
}

echo "[INFO] Starting php-fpm..."
exec php-fpm7.4 -F
