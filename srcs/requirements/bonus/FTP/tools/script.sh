#!/bin/bash
set -euo pipefail

if [ -z "$FTP_USER" ]; then
  echo "FTP_USER environment variable not set"
  exit 1
fi

if [ ! -f /run/secrets/ftp_pass ]; then
  echo "FTP password secret file missing"
  exit 1
fi

FTP_PASS=$(cat /run/secrets/ftp_pass)

# Create user only if doesn't exist
if ! id "$FTP_USER" &>/dev/null; then
  useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
  echo "${FTP_USER}:${FTP_PASS}" | chpasswd
else
  echo "User $FTP_USER already exists, skipping useradd"
fi

# Change ownership only if needed
CURRENT_OWNER=$(stat -c '%U' /var/www/html)
if [ "$CURRENT_OWNER" != "$FTP_USER" ]; then
  chown -R "$FTP_USER:$FTP_USER" /var/www/html
fi

CONTAINER_IP=$(hostname -I | awk '{print $1}')
sed -i "s|^# pasv_address=.*|pasv_address=${CONTAINER_IP}|" /etc/vsftpd.conf

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd.conf
