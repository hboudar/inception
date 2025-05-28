WORDPRESS_DIR = /home/hboudar/data/wordpress
MARIADB_DIR = /home/hboudar/data/mariadb

# Default target to build and start containers
working_dir:
	@docker run --rm -v $(MARIADB_DIR):/trash1 -v $(WORDPRESS_DIR):/trash2 \
		alpine sh -c "rm -rf trash1/* trash2/*"

# Build and start containers
up:
	cd srcs/ && docker compose up --build -d

# Show running containers
ps:
	@cd srcs/ && docker compose ps

# Remove all containers, networks, and volumes
clean:
	@cd srcs/ && docker compose down -v --remove-orphans
	@docker rmi -f $(shell docker images -q)

# Restart containers
re: down working_dir up