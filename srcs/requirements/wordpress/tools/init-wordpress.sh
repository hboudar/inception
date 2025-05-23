#!/bin/bash
set -e

echo "Waiting for database to be ready..."
until nc -z "$WORDPRESS_DB_HOST" 3306; do
  sleep 2
done

WP_DIR="/var/www/wordpress"

cd "$WP_DIR"

if [ ! -f wp-config.php ]; then
  wp config create \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --path="$WP_DIR" \
    --allow-root
fi

if ! wp core is-installed --allow-root; then
  wp core install \
    --url="https://localhost" \
    --title="42 Inception" \
    --admin_user="$ADMIN_NAME" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="admin@example.com" \
    --path="$WP_DIR" \
    --allow-root
  echo "✅ WordPress core installed."
fi

if ! wp user get "$USER_NAME" --allow-root > /dev/null 2>&1; then
  wp user create "$USER_NAME" "$USER_NAME@example.com" \
    --role=editor \
    --user_pass="$USER_PASSWORD" \
    --display_name="$USER_NAME" \
    --allow-root
  echo "✅ Editor user '$USER_NAME' created."
fi

if ! wp plugin is-installed redis-cache --allow-root; then
  wp plugin install redis-cache --activate --allow-root
  wp config set WP_REDIS_HOST 'redis' --allow-root
  wp config set WP_REDIS_PORT '6379' --allow-root
  wp config set WP_CACHE true --raw --allow-root
  wp config set FS_METHOD 'direct' --allow-root
  wp redis enable --allow-root
  echo "✅ Redis cache configured."
fi

chown -R www-data:www-data "$WP_DIR"
chmod -R 755 "$WP_DIR"

mkdir -p /run/php
echo "✅ Environment ready. Starting PHP-FPM..."

exec php-fpm7.4 -F
