FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx openssl \
    && apt-get clean

RUN mkdir -p /etc/ssl/private /etc/ssl/certs

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=localhost"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]