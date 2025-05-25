FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client \
    && apt-get clean

EXPOSE 3306

COPY tools/init-maria.sh .

RUN chmod +x init-maria.sh

CMD ["./init-maria.sh"] 