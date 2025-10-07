#!/bin/bash
set -euo pipefail

# Read FTP password securely from Docker secret file
FTP_PASS=$(< /run/secrets/ftp_pass)

# Ensure the shared group (used by both WordPress and FTP) exists
getent group webgroup >/dev/null || groupadd -g 1000 webgroup

# Create FTP user if it doesn’t already exist
if ! getent passwd "$FTP_USER" >/dev/null; then
  useradd -u 1001 -d /var/www/html -s /usr/sbin/nologin -M -N -g webgroup "$FTP_USER"  # Create user without home or mail
  echo "$FTP_USER:$FTP_PASS" | chpasswd  # Set FTP password
  echo "[FTP] : Created."
fi

# Ensure /usr/sbin/nologin is listed as a valid shell (required by vsftpd)
grep -q "^/usr/sbin/nologin$" /etc/shells || echo "/usr/sbin/nologin" >> /etc/shells

# Start vsftpd (FTP server) in the foreground
echo "[FTP] : Start vsftpd in foreground..."
exec vsftpd /etc/vsftpd.conf
