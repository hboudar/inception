FROM debian:bullseye

# Install vsftpd, ftp, openssl, netcat (netcat-openbsd is standard netcat)
RUN apt-get update && apt-get install -y \
    vsftpd ftp openssl netcat-openbsd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create vsftpd empty directory (required)
RUN mkdir -p /var/run/vsftpd/empty

# Add script and config
COPY tools/script.sh /usr/local/bin/
COPY conf/vsftpd.conf /etc/vsftpd.conf
RUN chmod +x /usr/local/bin/script.sh

# Expose ports: 2121 (command) and passive ports 30000-30100
EXPOSE 2121 30000-30100

# Start script
CMD ["/usr/local/bin/script.sh"]
