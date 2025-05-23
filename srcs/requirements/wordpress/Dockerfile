FROM debian:bullseye

# Install PHP, extensions, and utilities
RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-gd php-curl php-xml php-mbstring php-zip \
    curl unzip wget less procps vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM to listen on port 9000 (instead of UNIX socket)
RUN sed -i 's|listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf && \
    sed -i 's|;listen.owner = .*|listen.owner = www-data|' /etc/php/*/fpm/pool.d/www.conf && \
    sed -i 's|;listen.group = .*|listen.group = www-data|' /etc/php/*/fpm/pool.d/www.conf

# Create WordPress root
RUN mkdir -p /var/www/wordpress

# Download and extract latest WordPress
WORKDIR /tmp

RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/wordpress && \
    rm -rf wordpress latest.tar.gz

# Set correct ownership and permissions
RUN chown -R www-data:www-data /var/www/wordpress && \
    chmod -R 755 /var/www/wordpress

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Add init script
COPY tools/init-wordpress.sh /init-wordpress.sh
RUN chmod +x /init-wordpress.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

CMD ["/init-wordpress.sh"]
