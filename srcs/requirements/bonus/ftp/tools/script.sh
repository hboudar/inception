#!/bin/bash
set -euo pipefail

# Validate environment variables
if [ -z "${FTP_USER:-}" ]; then
  echo "Error: FTP_USER not set" >&2
  exit 1
fi

if [ ! -f /run/secrets/ftp_pass ]; then
  echo "Error: FTP password secret missing" >&2
  exit 1
fi

FTP_PASS=$(< /run/secrets/ftp_pass)

# Create ftp user if not exists
if ! id "$FTP_USER" &>/dev/null; then
  echo "Creating user $FTP_USER..."
  useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
  echo "${FTP_USER}:${FTP_PASS}" | chpasswd
  usermod -aG www-data "$FTP_USER"  # Allow access to group-owned dirs
else
  echo "User $FTP_USER already exists"
fi

# Fix permissions recursively on first run
echo "Fixing permissions under /var/www/html..."
chown -R "$FTP_USER:www-data" /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Dynamically set passive IP
CONTAINER_IP=$(hostname -I | awk '{print $1}')
sed -i "/^pasv_address=/d" /etc/vsftpd.conf
echo "pasv_address=${CONTAINER_IP}" >> /etc/vsftpd.conf

echo "Starting vsftpd with IP $CONTAINER_IP..."
exec vsftpd /etc/vsftpd.conf
