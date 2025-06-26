SHELL := /bin/bash
.ONESHELL:

# === Paths ===
DATA_DIR = /home/hboudar/data
WORDPRESS_DIR = $(DATA_DIR)/wordpress
MARIADB_DIR = $(DATA_DIR)/mariadb

# === Color codes ===
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
NC=\033[0m

# === Main Targets ===
up: working_dirs
	@cd srcs/ && docker compose up --build -d

working_dirs:
	@if [ -n "$$(ls -A $(DATA_DIR) 2>/dev/null)" ]; then \
		echo -e "$(YELLOW)$(DATA_DIR) is not empty.$(NC)"; \
		read -p "Do you want to remove and recreate $(DATA_DIR)? [y/n] " ans; \
		ans=$$(echo $$ans | tr '[:upper:]' '[:lower:]'); \
		if [[ "$$ans" == "y" ]]; then \
			echo -e "$(RED)Recreating directories...$(NC)"; \
			( docker run --rm -v $(DATA_DIR):/trash alpine sh -c "rm -rf /trash/*" >/dev/null 2>&1 ); \
			( mkdir -p $(WORDPRESS_DIR) $(MARIADB_DIR) >/dev/null 2>&1 ); \

		else \
			echo -e "$(GREEN)Keeping existing directories.$(NC)"; \
		fi; \
	else \
		echo -e "$(GREEN)$(DATA_DIR) is empty. Creating subdirectories...$(NC)"; \
		mkdir -p $(WORDPRESS_DIR) $(MARIADB_DIR); \
	fi

down:
	@cd srcs/ && docker compose down -v --remove-orphans

fdown: down
	@docker run --rm -v $(DATA_DIR):/trash alpine sh -c "rm -rf /trash/*"
	@rm -rf $(WORDPRESS_DIR) $(MARIADB_DIR)
	@docker network rm -f my-net
	@docker volume prune -af
	@docker image prune -af

re: down up
