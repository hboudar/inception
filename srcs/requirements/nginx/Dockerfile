FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y \
    nginx openssl \
    && apt-get clean


# RUN mkdir -p /etc/ssl/private /etc/ssl/certs \
#     && openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/nginx.key \
#     -out /etc/ssl/certs/nginx.crt -days 365 -nodes -subj "/CN=localhost"

RUN mkdir -p /etc/ssl/private /etc/ssl/certs \
    && openssl genrsa -out /etc/ssl/private/nginx.key 4096 \
    && openssl req -new -key /etc/ssl/private/nginx.key \
       -out /tmp/nginx.csr -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=localhost" \
    && openssl x509 -req -days 365 -in /tmp/nginx.csr \
       -signkey /etc/ssl/private/nginx.key \
       -out /etc/ssl/certs/nginx.crt \
    && rm /tmp/nginx.csr

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]