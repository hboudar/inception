FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    vsftpd ftp openssl netcat-openbsd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

#removed net-tools from installation 

# Prepare vsftpd
RUN mkdir -p /var/run/vsftpd/empty \
 && touch /var/log/vsftpd.log \
 && chmod 644 /var/log/vsftpd.log

# Copy configuration and startup script
COPY tools/script.sh /usr/local/bin/
COPY conf/vsftpd.conf /etc/vsftpd.conf
RUN chmod +x /usr/local/bin/script.sh

# Expose command and passive ports
EXPOSE 2121 30000-30100

# Entry point
CMD ["/usr/local/bin/script.sh"]
