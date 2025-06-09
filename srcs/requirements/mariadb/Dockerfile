FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3306

COPY tools/init-maria.sh .

# At the end of Dockerfile
RUN chown -R mysql:mysql /var/lib/mysql

CMD ["bash", "./init-maria.sh"]
