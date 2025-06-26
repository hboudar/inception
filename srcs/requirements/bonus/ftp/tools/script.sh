#!/bin/bash
set -euo pipefail

# Validate required env
if [ -z "${FTP_USER:-}" ]; then
  echo "Error: FTP_USER not set" >&2
  exit 1
fi

if [ ! -f /run/secrets/ftp_pass ]; then
  echo "Error: FTP password secret missing" >&2
  exit 1
fi

FTP_PASS=$(< /run/secrets/ftp_pass)

getent group webgroup >/dev/null || groupadd -g 1000 webgroup # Ensure shared group for WP and FTP exists

id -nG www-data | grep -qw webgroup || usermod -aG webgroup www-data # Add www-data to shared group if not already a member

# Create FTP user if not exists
if ! getent passwd "$FTP_USER" >/dev/null; then
  useradd -u 1001 -d /var/www/html -s /bin/bash -M -N -g webgroup "$FTP_USER"
  echo "${FTP_USER}:${FTP_PASS}" | chpasswd
fi

id -nG "$FTP_USER" | grep -qw webgroup || usermod -aG webgroup "$FTP_USER" # Add FTP user to group if not already a member


umask 0002
chown -R "$FTP_USER":webgroup /var/www/html
chmod -R g+rwX /var/www/html
find /var/www/html -type d -exec chmod 2775 {} \;
find /var/www/html -type f -exec chmod 664 {} \;

sed -i '/^pasv_address=/d' /etc/vsftpd.conf
echo "pasv_address=${PASV_ADDRESS:-127.0.0.1}" >> /etc/vsftpd.conf

pgrep vsftpd > /dev/null || exec vsftpd /etc/vsftpd.conf