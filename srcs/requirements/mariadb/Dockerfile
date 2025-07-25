FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3306

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY tools/init-maria.sh .
COPY tools/healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chown -R mysql:mysql /var/lib/mysql
RUN chmod +x /usr/local/bin/healthcheck.sh

CMD ["./init-maria.sh"]
