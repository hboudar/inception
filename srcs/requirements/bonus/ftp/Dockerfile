FROM debian:bullseye

# Install only necessary packages
RUN apt-get update && apt-get install -y \
    vsftpd netcat-openbsd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Prepare vsftpd environment
RUN mkdir -p /var/run/vsftpd/empty \
 && touch /var/log/vsftpd.log \
 && chmod 644 /var/log/vsftpd.log

# Copy configuration and script
COPY tools/script.sh /usr/local/bin/
COPY conf/vsftpd.conf /etc/vsftpd.conf
RUN chmod +x /usr/local/bin/script.sh

# Passive FTP and command port
EXPOSE 21 30000-30100

# Startup
CMD ["/usr/local/bin/script.sh"]
