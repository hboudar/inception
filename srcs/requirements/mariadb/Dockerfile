FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    apt-get clean
# rm -rf /var/lib/apt/lists/*

EXPOSE 3306
    
COPY ./tools/init-mariadb.sh .
RUN chmod +x init-mariadb.sh

CMD ["./init-mariadb.sh"]