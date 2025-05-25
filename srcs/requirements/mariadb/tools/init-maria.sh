#!/bin/bash

# Start mysqld_safe in the background
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql' &

# Wait for MariaDB to be ready
until mysqladmin ping --silent; do
  echo "Waiting for MariaDB to start..."
  sleep 1
done

# Initialize DB and users
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';"

# Keep the container running with mysqld_safe in foreground
wait
