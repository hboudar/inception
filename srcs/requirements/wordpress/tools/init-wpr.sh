#!/bin/bash

set -euo pipefail
trap 'echo "[ERROR] Script failed at line $LINENO"' ERR

echo "[INFO] Waiting for $DB_HOST..."
until mysqladmin ping -h "$DB_HOST" --silent; do
  sleep 2
done
echo "[INFO] MariaDB is available."

cd /var/www/html

if ! command -v wp >/dev/null 2>&1; then
  echo "[INFO] Installing WP-CLI..."
  curl -sSLO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

DB_PASS=$(< /run/secrets/db_pass)
ADMIN_PASS=$(< /run/secrets/admin_pass)
USER_PASS=$(< /run/secrets/user_pass)
FORBIDDEN_PATTERN='admin|administrator'

if [ ! -f wp-config.php ]; then
  echo "[INFO] Setting up WordPress..."

  wp core download --allow-root

  # Create wp-config.php with DB credentials
  wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --allow-root \
    --skip-check

  if echo "$ADMIN_USER" | grep -qiE "$FORBIDDEN_PATTERN"; then
      echo "[WARNING] Invalid admin username '$ADMIN_USER'. Using fallback 'supervisor42'."
      ADMIN_USER="supervisor42"
  fi

  # Install WordPress site
  wp core install \
    --url="$DOMAIN" \
    --title="$TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASS" \
    --admin_email="$ADMIN_EMAIL" \
    --allow-root

  # Redis caching plugin setup
  wp plugin install redis-cache --allow-root
  wp plugin activate redis-cache --allow-root

  wp config set WP_REDIS_HOST 'redis' --allow-root
  wp config set WP_REDIS_PORT '6379' --allow-root
  wp config set WP_CACHE 'true' --allow-root
  wp config set FS_METHOD 'direct' --allow-root

  wp redis enable --allow-root

  # Create additional WordPress user
  wp user create \
    "$USER_NAME" "$USER_EMAIL" \
    --role=author \
    --user_pass="$USER_PASS" \
    --allow-root
else
  echo "[INFO] WordPress already set up."
fi

getent group webgroup >/dev/null || groupadd -g 1000 webgroup # Create shared group if it doesn't exist
id -nG www-data | grep -qw webgroup || usermod -aG webgroup www-data # Add www-data to group if needed
getent passwd "$FTP_USER" >/dev/null || useradd -u 1001 -g webgroup -M -N "$FTP_USER" # Create FTP user if not exists
id -nG "$FTP_USER" | grep -qw webgroup || usermod -aG webgroup "$FTP_USER" # Ensure FTP user is in the group

# Set file permissions for WordPress files
umask 0002
chown -R www-data:webgroup /var/www/html
find /var/www/html -type d -exec chmod g+rwxs {} \;
find /var/www/html -type f -exec chmod g+rw {} \;

# Ensure PHP-FPM listens on TCP 9000
grep -q "listen = 0.0.0.0:9000" /etc/php/7.4/fpm/pool.d/www.conf || \
  sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Redirect PHP-FPM logs to Docker stdout/stderr
sed -i 's|^error_log = .*|error_log = /proc/self/fd/2|' /etc/php/7.4/fpm/php-fpm.conf

# Start PHP-FPM in foreground (main container process)
echo "[INFO] Starting php-fpm..."
exec php-fpm7.4 -F