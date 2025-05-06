#!/bin/sh

# Initialize DB directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB in safe mode and run setup commands
mysqld_safe --datadir=/var/lib/mysql &

sleep 5

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

# Bring MariaDB to foreground
wait
