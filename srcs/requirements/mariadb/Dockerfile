FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3306

COPY tools/init-maria.sh .
RUN chown -R mysql:mysql /var/lib/mysql

COPY tools/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

CMD ["bash", "./init-maria.sh"]
