#!/bin/bash
set -euo pipefail
trap 'echo "[ERROR] Script failed at line $LINENO"' ERR


FTP_PASS=$(< /run/secrets/ftp_pass)

getent group webgroup >/dev/null || groupadd -g 1000 webgroup

# Create FTP user if it doesn’t already exist
if ! getent passwd "$FTP_USER" >/dev/null; then
  useradd -u 1001 -d /var/www/html -s /usr/sbin/nologin -M -N -g webgroup "$FTP_USER"
  echo "$FTP_USER:$FTP_PASS" | chpasswd
  echo "[FTP] : Created."
fi

# Ensure /usr/sbin/nologin is listed as a valid shell (required by vsftpd)
grep -q "^/usr/sbin/nologin$" /etc/shells || echo "/usr/sbin/nologin" >> /etc/shells

echo "[FTP] : Start vsftpd in foreground..."
exec vsftpd /etc/vsftpd.conf
