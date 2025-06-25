FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-xml \
    php7.4-mbstring \
    mariadb-client \
    curl \
    wget \
    unzip \
    && apt-get clean

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html
RUN mkdir -p /run/php


COPY tools/init-wpr.sh .
RUN chmod +x init-wpr.sh

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html/

EXPOSE 9000

CMD ["./init-wpr.sh"]
