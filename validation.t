docker : a tool designed to build deploy, and run applications using containers
docker-compos : tool that orchestrates multiple containers
    in an isolated environment, accrose different operating-systems;

benefit of docker compared to VMs :  containers virtualize the operating system, while VM virtualize the hardware.
lightweight, portability, faster startup, resources efficiency, simpler deployment.


nginx, mariadb, worldpress
redis, adminer, ftp, static-site, health-monitor

nginx--------------------------------------------------------------------
🌐 Config
events {} → required, handles connections.
http {} → main block for servers & settings.

#HTTPS (443)
listen 443 ssl; → HTTPS enabled.
server_name hboudar.42.fr; → domain name.
SSL:
ssl_certificate = public cert.
ssl_certificate_key = private key.
ssl_protocols TLSv1.3; → secure protocol.

#Root & Index
root /var/www/html; → serve site files.
index index.php index.html; → default files.

#Logs
access_log → requests.
error_log → errors.

#PHP
Match \.php$ → forward to wordpress:9000 (php-fpm).

#Static Files
Cache 7 days, don’t log.

#HTTP → HTTPS
Port 80 block → redirect to HTTPS with return 301.

🐳 Dockerfile
Install packages:
nginx → web server.
openssl → generate SSL/TLS certificates.

curl → test HTTP requests.
req → start the certificate request/creation process
-x509 → create self-signed X.509 cert.
-nodes → no password on private key.
-days 365 → valid for 1 year.
-newkey rsa:2048 → generate new 2048-bit RSA key.
-keyout / -out → where to save key + cert.
-subj → certificate subject (country, org, CN=localhost).
COPY conf/nginx.conf /etc/nginx/nginx.conf → custom Nginx config.

EXPOSE 443 → HTTPS port.
CMD ["nginx", "-g", "daemon off;"] → run Nginx in foreground so container doesn’t stop.
-------------------------------------------------------------------------
mariadb------------------------------------------------------------------
mariadb-server → installs MariaDB server.

apt-get clean && rm -rf /var/lib/apt/lists/* → reduces image size.

3306 → standard MariaDB port.

Prepare runtime dir: mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld → ensures MariaDB can create socket file.

Copy scripts:
init-maria.sh → initializes DB, creates users/databases, starts MariaDB.
healthcheck.sh → checks if MariaDB is alive.

Set permissions:

chown -R mysql:mysql /var/lib/mysql → ensure DB files owned by MariaDB user.
chmod +x /usr/local/bin/healthcheck.sh → make healthcheck executable.

CMD: ["./init-maria.sh"] → container runs this script as main process (not in background).


init-maria.sh Notes

Purpose: Initialize MariaDB on first run, then start in foreground.
Shell settings: #!/bin/bash, set -euo pipefail, trap errors.
Key variables:
DB directory check: If /var/lib/mysql/mysql missing → mysql_install_db to create system tables.
Initialization (first run only):
Start temporary MariaDB with mysqld_safe --skip-networking &.
Wait with mysqladmin ping until ready.
Run SQL to:
Create $DB_NAME database.
Create $DB_USER with privileges.
Set root password.
Flush privileges.
Create INIT_FLAG.
Shutdown temporary MariaDB with mysqladmin shutdown.
Normal start: exec mysqld_safe --datadir=/var/lib/mysql --socket=$SOCKET --port=3306 --bind-address=0.0.0.0 → foreground, accessible from container network.
-------------------------------------------------------------------------