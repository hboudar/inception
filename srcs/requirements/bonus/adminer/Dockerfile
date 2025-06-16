FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-mysqli curl unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Remove any existing index.html or adminer.php before download
RUN rm -f index.html adminer.php && \
    curl -L https://www.adminer.org/latest.php -o index.php && \
    chmod 644 index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080"]
