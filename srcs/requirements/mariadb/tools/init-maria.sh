#!/bin/bash
set -euo pipefail

# Constants
INIT_FLAG="/var/lib/mysql/.inception_initialized"

# Start MariaDB in background
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql' &
echo "[INFO] Starting MariaDB..."

# Wait for MariaDB to become responsive
until mysqladmin ping --silent --connect-timeout=2 > /dev/null; do
  echo "[INFO] Waiting for MariaDB to be ready..."
  sleep 1.5
done
echo "[INFO] MariaDB is ready."

# Read secrets
DB_PASS=$(cat /run/secrets/db_pass)
ROOT_PASS=$(cat /run/secrets/root_pass)

# Only initialize if flag doesn't exist
if [ ! -f "$INIT_FLAG" ]; then
  echo "[INFO] Performing one-time DB initialization..."

  mysql <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
    CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
    GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
    FLUSH PRIVILEGES;
EOSQL

  # Set root password (may fail if already set, warn only)
  if mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';"; then
    echo "[INFO] Root password set."
  else
    echo "[WARN] Failed to reset root password. It may already be set."
  fi

  touch "$INIT_FLAG"
  echo "[INFO] Initialization complete."
else
  echo "[INFO] Skipping DB setup — already initialized."
fi

# Keep the container alive
wait