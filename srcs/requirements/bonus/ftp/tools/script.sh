#!/bin/bash
set -euo pipefail

FTP_PASS=$(< /run/secrets/ftp_pass)

getent group webgroup >/dev/null || groupadd -g 1000 webgroup # Ensure shared group for WP and FTP exists

if ! getent passwd "$FTP_USER" >/dev/null; then
  useradd -u 1001 -d /var/www/html -s /usr/sbin/nologin -M -N -g webgroup "$FTP_USER"
  echo "$FTP_USER:$FTP_PASS" | chpasswd
  echo "[FTP] : Created."
fi
grep -q "^/usr/sbin/nologin$" /etc/shells || echo "/usr/sbin/nologin" >> /etc/shells

echo "[FTP] : Start vsftpd in foreground..."
exec vsftpd /etc/vsftpd.conf