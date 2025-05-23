FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y mariadb-server mariadb-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup data dir permissions and expose default port
VOLUME /var/lib/mysql
EXPOSE 3306

COPY ./my.cnf /etc/mysql/my.cnf

CMD ["mysqld_safe"]

