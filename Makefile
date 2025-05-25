# Build and start containers
up:
	cd srcs/ && docker compose up --build -d

# Stop and remove containers
down:
	cd srcs/ && docker compose down --remove-orphans

# Restart containers
re: down up

# Show running containers
ps:
	@cd srcs/ && docker compose ps

WORDPRESS_DIR = /home/alaalalm/data/wordpress
MARIADB_DIR = /home/alaalalm/data/mariadb

# Target to remove the bind mounts
remove_bind_mounts:
	@echo "Bind mounts removed"
	@rm -rf $(WORDPRESS_DIR)/*
	@rm -rf $(MARIADB_DIR)/*

# Remove all containers, networks, and volumes
clean: down
	@cd srcs/ && docker compose down -v
	@make remove_bind_mounts
	@docker rmi -f $(shell docker images -q)