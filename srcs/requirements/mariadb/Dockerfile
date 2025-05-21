# srcs/requirements/mariadb/Dockerfile

FROM mariadb:10.11

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./tools/init.sql.template /docker-entrypoint-initdb.d/init.sql.template

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld"]
