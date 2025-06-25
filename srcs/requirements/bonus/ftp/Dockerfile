FROM debian:bullseye

# Install only needed packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    vsftpd netcat-openbsd \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create necessary runtime dirs and logs
RUN mkdir -p /var/run/vsftpd/empty && \
    touch /var/log/vsftpd.log && \
    chmod 644 /var/log/vsftpd.log

# Copy configs and init script
COPY tools/script.sh /usr/local/bin/
COPY conf/vsftpd.conf /etc/vsftpd.conf
RUN chmod +x /usr/local/bin/script.sh

# Expose control and passive ports
EXPOSE 21 30000-30100

# Start FTP service via script
CMD ["/usr/local/bin/script.sh"]
