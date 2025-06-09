#!/bin/bash
set -euo pipefail

# Start MariaDB in background
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql' &

# Wait for server to be ready
until mysqladmin ping --silent --connect-timeout=2; do
  echo "[INFO] Waiting for MariaDB to start..."
  sleep 1.5
done

# Read secrets
DB_PASS=$(cat /run/secrets/db_pass)
ROOT_PASS=$(cat /run/secrets/root_pass)

# Initialization
mysql <<-EOSQL
  CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
  CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
  GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
  FLUSH PRIVILEGES;
  ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';
EOSQL

# Keep container alive
wait
