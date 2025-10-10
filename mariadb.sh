#!/bin/bash
# Use bash as interpreter

set -euo pipefail
# -e: Exit immediately if any command returns a non-zero exit code
# -u: Treat using an unset variable as an error and exit
# -o pipefail: If any command in a pipeline fails, the entire pipeline fails

trap 'echo "[ERROR] Script failed at line $LINENO"' ERR
# If an error occurs anywhere, print the line number where it failed

# File that marks whether DB was initialized previously
INIT_FLAG="/var/lib/mysql/.inception_initialized"

# Path to the MariaDB socket (used for local connections)
SOCKET="/run/mysqld/mysqld.sock"

echo "[INFO] Checking if database directory is empty..."
# If the default system database folder doesn't exist, DB hasn't been initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Running mysql_install_db to initialize system tables..."
    # Create the default MariaDB system tables (mysql, information_schema, etc.)
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Read database passwords from Docker secrets
DB_PASS=$(< /run/secrets/db_pass)
ROOT_PASS=$(< /run/secrets/root_pass)

# If the DB hasn't been initialized before (INIT_FLAG doesn't exist)
if [ ! -f "$INIT_FLAG" ]; then
    echo "[INFO] Running first-time DB initialization..."

    # Start a temporary MariaDB server with no networking (local-only)
    mysqld_safe --datadir='/var/lib/mysql' --socket=${SOCKET} --skip-networking &
    temp_pid=$!
    # Store the background process ID so we can stop/wait for it later

    echo "[INFO] Waiting for MariaDB (init) to become ready..."
    # Wait until MariaDB accepts connections via socket
    until mysqladmin ping --protocol=socket --socket=${SOCKET} --silent; do
        sleep 1
    done

    # Run SQL commands to set up the initial database, user, and root password
    mysql --protocol=socket --socket=${SOCKET} <<-EOSQL
        -- Create the main DB if not exists
        CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;

        -- Create the non-root DB user (if not exists)
        CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';

        -- Give that user full permissions on the DB just created
        GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';

        -- Change the root password
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';

        -- Reload privilege changes
        FLUSH PRIVILEGES;
EOSQL

    # Create a file to indicate the DB was already initialized
    touch "$INIT_FLAG"

    echo "[INFO] Shutting down temporary MariaDB..."
    # Gracefully stop the temporary MariaDB using the new root credentials
    mysqladmin --protocol=socket --socket=${SOCKET} -uroot -p"$ROOT_PASS" shutdown

    # Wait for the process to finish
    wait "$temp_pid"

    echo "[INFO] Database initialization complete."
else
    echo "[INFO] Skipping DB setup — already initialized."
fi

echo "[INFO] Starting MariaDB in foreground..."
# Start the real server in the foreground, listening on all IPs (for container)
exec mysqld_safe --datadir='/var/lib/mysql' --socket=${SOCKET} --port=3306 --bind-address=0.0.0.0
# 'exec' replaces the shell with the MariaDB process so it becomes PID 1
