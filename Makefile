# === Paths ===
DATA_DIR = /home/hboudar/data
WORDPRESS_DIR = $(DATA_DIR)/wordpress
MARIADB_DIR = $(DATA_DIR)/mariadb

# === Color codes ===
GREEN=\033[0;32m
YELLOW=\033[1;33m
NC=\033[0m

# === Main Targets ===
up: working_dirs
	@cd srcs/ && docker compose up --build -d

working_dirs:
	@if [ -n "$$(ls -A $(DATA_DIR) 2>/dev/null)" ]; then \
		echo -e "$(YELLOW)$(DATA_DIR) is not empty.$(NC)"; \
	else \
		echo -e "$(GREEN)$(DATA_DIR) is empty. Creating subdirectories...$(NC)"; \
	fi; \
	mkdir -p $(WORDPRESS_DIR) $(MARIADB_DIR);

down:
	@cd srcs/ && docker compose down -v --remove-orphans
	@docker run --rm -v $(DATA_DIR):/trash alpine sh -c "rm -rf /trash/*"
	@rm -rf $(WORDPRESS_DIR) $(MARIADB_DIR)
	@docker image prune -af
	@docker network prune -f
	@docker volume prune -af

re: down up
.PHONY: up down re working_dirs