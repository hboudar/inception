#!/bin/bash
set -euo pipefail
trap 'echo "[ERROR] Script failed at line $LINENO"' ERR

INIT_FLAG="/var/lib/mysql/.inception_initialized"
SOCKET="/run/mysqld/mysqld.sock"

echo "[INFO] Checking if database directory is empty..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Running mysql_install_db to initialize system tables..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo "[INFO] Starting MariaDB..."
mysqld_safe --datadir='/var/lib/mysql' --socket=${SOCKET} --port=3306 --bind-address=0.0.0.0 &
pid="$!"

echo "[INFO] Waiting for MariaDB to become ready..."
until mysqladmin ping --protocol=socket --socket=${SOCKET} --silent; do
    sleep 1
done
echo "[INFO] MariaDB is ready."

DB_PASS=$(< /run/secrets/db_pass)
ROOT_PASS=$(< /run/secrets/root_pass)

if [ ! -f "$INIT_FLAG" ]; then
    echo "[INFO] Running first‑time DB initialization..."
    mysql --protocol=socket --socket=${SOCKET} <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
        CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
        GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';
        FLUSH PRIVILEGES;
EOSQL
    touch "$INIT_FLAG"
    echo "[INFO] Database initialization complete."
else
    echo "[INFO] Skipping DB setup — already initialized."
fi

echo "[INFO] MariaDB started and ready. Handing over to foreground process..."
wait "$pid"
