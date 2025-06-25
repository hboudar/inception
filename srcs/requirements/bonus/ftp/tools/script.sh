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

# Ensure shared group for WP and FTP exists
if ! getent group webftp >/dev/null; then
  groupadd -g 1000 webftp
fi

usermod -aG webftp www-data || true

# === Create FTP user if not exists ===
if ! id "$FTP_USER" &>/dev/null; then
  useradd -u 1001 -d /var/www/html -s /bin/bash "$FTP_USER"
  echo "${FTP_USER}:${FTP_PASS}" | chpasswd
  usermod -aG webftp "$FTP_USER"
fi

# Add FTP user and www-data to shared group (idempotent)
if ! id -nG "$FTP_USER" | grep -qw webftp; then
  usermod -aG webftp "$FTP_USER"
fi


# Adjust ownership/permissions safely
chown -R "$FTP_USER":webftp /var/www/html
chmod -R g+rwX /var/www/html
find /var/www/html -type d -exec chmod 2775 {} \;
find /var/www/html -type f -exec chmod 664 {} \;

# Configure passive IP dynamically
sed -i '/^pasv_address=/d' /etc/vsftpd.conf
echo "pasv_address=${PASV_ADDRESS:-127.0.0.1}" >> /etc/vsftpd.conf

# === Optional debug logs ===
# echo "[INFO] FTP user: $FTP_USER"
# id "$FTP_USER"
# ls -ld /var/www/html

umask 002
# Run FTP server
pgrep vsftpd > /dev/null || exec vsftpd /etc/vsftpd.conf