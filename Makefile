WORDPRESS_DIR = /home/hboudar/data/wordpress
MARIADB_DIR = /home/hboudar/data/mariadb

working_dir:
	@docker run --rm -v $(MARIADB_DIR):/trash1 -v $(WORDPRESS_DIR):/trash2 \
		alpine sh -c "rm -rf trash1/* trash2/*" && \
		mkdir -p $(WORDPRESS_DIR) $(MARIADB_DIR)

up: working_dir
	@cd srcs/ && docker compose up --build -d

down:
	@cd srcs/ && docker compose down -v --remove-orphans
	@docker image prune -af

re : down up