FROM alpine:3.18

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY ./conf/my.cnf /etc/my.cnf
COPY ./tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/init.sh"]
