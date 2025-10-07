FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-mysqli curl unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory where Adminer will be placed
WORKDIR /var/www/html

# Ensure a clean environment, then download the latest Adminer PHP file
RUN rm -f index.html adminer.php && \
    curl -L https://www.adminer.org/latest.php -o index.php && \
    chmod 644 index.php

# Expose port 8080 (Adminer will be accessible through this port)
EXPOSE 8080

# Run a built-in PHP development server that serves Adminer
CMD ["php", "-S", "0.0.0.0:8080"]
