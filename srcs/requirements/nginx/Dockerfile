FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y \
    nginx openssl \
    && apt-get clean


RUN mkdir -p /etc/ssl/private /etc/ssl/certs \
    && openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt -days 365 -nodes -subj "/CN=localhost"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]