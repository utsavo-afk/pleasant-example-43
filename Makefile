.PHONY: dev-up dev-down dev-build dev-logs dev-shell \
		prod-up prod-down prod-build prod-logs prod-shell \
		deploy-webapp \
		restart-gateway restart-prod-services \
		ps clean help remind-me

# Configurable variables
COMPOSE_DEV=docker-compose.development.yaml
COMPOSE_PROD=docker-compose.production.yaml
API_BASE_URL ?= http://caddy:80/api

## ---------- Development ---------- ##

dev-up:
	@echo "Starting development environment..."
	@echo "Using API_BASE_URL=$(API_BASE_URL)"
	docker compose -f $(COMPOSE_DEV) build --build-arg API_BASE_URL=$(API_BASE_URL)
	docker compose -f $(COMPOSE_DEV) up
	@echo "Development environment started successfully."

dev-down:
	@echo "Stopping development environment..."
	docker compose -f $(COMPOSE_DEV) down
	@echo "Development environment stopped successfully."
	@echo "To clean up all containers and volumes, run 'make clean'."

dev-build:
	@echo "Building development images..."
	docker compose -f $(COMPOSE_DEV) build --build-arg API_BASE_URL=$(API_BASE_URL)
	@echo "Development images built successfully."
	@echo "To start the development environment, run 'make dev-up'."

dev-logs:
	@echo "Viewing development logs..."
	@echo "To stop the logs, press Ctrl+C."
	@echo "To open a shell in the web container, run 'make dev-shell'."
	docker compose -f $(COMPOSE_DEV) logs -f

dev-shell:
	@echo "Opening shell in development web container..."
	@echo "To stop the shell, type 'exit'."
	docker compose -f $(COMPOSE_DEV) exec webapp sh

## ---------- Production ---------- ##

prod-up:
	@echo "Starting production environment..."
	@echo "Using API_BASE_URL=$(API_BASE_URL)"
	docker compose -f $(COMPOSE_PROD) build --build-arg API_BASE_URL=$(API_BASE_URL)
	docker compose -f $(COMPOSE_PROD) up -d
	@echo "Production environment started successfully."
	@echo "To view logs, run 'make prod-logs'."
	@echo "To open a shell in the web container, run 'make prod-shell'."

# WARNING! You will most likely not need to run this in your prod env
prod-down:
	@echo "Stopping production environment..."
	docker compose -f $(COMPOSE_PROD) down
	@echo "Production environment stopped successfully."

# WARNING! You will most likely not need to run this in your prod env
prod-build:
	@echo "Building production images (no cache)..."
	@echo "Using API_BASE_URL=$(API_BASE_URL)"
	docker compose -f $(COMPOSE_PROD) build --no-cache --build-arg API_BASE_URL=$(API_BASE_URL)
	@echo "Production images built successfully."
	@echo "To start the production environment, run 'make prod-up'."

prod-logs:
	@echo "Viewing production logs..."
	@echo "To stop the logs, press Ctrl+C."
	@echo "To open a shell in the web container, run 'make prod-shell'."
	docker compose -f $(COMPOSE_PROD) logs -f

prod-shell:
	@echo "Opening shell in production web container..."
	@echo "To stop the shell, type 'exit'."
	@echo "To view logs, run 'make prod-logs'."
	docker compose -f $(COMPOSE_PROD) exec webapp sh

restart-gateway:
	@echo "🔁 Restarting Caddy gateway..."
	docker compose -f $(COMPOSE_PROD) restart caddy
	@echo "✅ Gateway restarted successfully."

# ✅ CI/CD-safe deployment: rebuild only webapp and restart it
deploy-webapp: check-prod-dependencies
	@echo "🔁 Rebuilding and restarting only the webapp service..."
	docker compose -f $(COMPOSE_PROD) build webapp --build-arg API_BASE_URL=$(API_BASE_URL)
	@echo "🧹 Cleaning up old Docker images..."
	docker image prune -f
	docker compose -f $(COMPOSE_PROD) up -d webapp
	@echo "✅ Webapp service rebuilt and restarted successfully."

restart-prod-services:
	@echo "♻️ Restarting all production services without removing containers..."
	docker compose -f $(COMPOSE_PROD) restart
	@echo "✅ All production services restarted."

## ---------- Utility ---------- ##

# Internal utility to ensure all required services are running before deploying webapp
check-prod-dependencies:
	@echo "🔍 Checking if required services are up (db, caddy)..."
	# @if ! docker compose -f $(COMPOSE_PROD) ps db | grep -q "Up"; then \
	# 	echo "❌ ERROR: 'db' service is not running. Start it before deploying."; \
	# 	exit 1; \
	# fi
	@if ! docker compose -f $(COMPOSE_PROD) ps caddy | grep -q "Up"; then \
		echo "❌ ERROR: 'caddy' service is not running. Start it before deploying."; \
		exit 1; \
	fi
	@echo "✅ All required services are running."

ps:
	docker ps

# WARNING! You will most likely not need to run this in your prod env
clean:
	@echo "Cleaning up all containers and volumes..."
	docker compose -f $(COMPOSE_DEV) down -v --remove-orphans
	docker compose -f $(COMPOSE_PROD) down -v --remove-orphans
	docker system prune -f

help:
	@echo "Makefile commands:"
	@echo "  dev-up                - Start development environment"
	@echo "  dev-down              - Stop development environment"
	@echo "  dev-build             - Build development images"
	@echo "  dev-logs              - View development logs"
	@echo "  dev-shell             - Open shell in development container"
	@echo "  prod-up               - Start entire production environment (⚠️ use rarely)"
	@echo "  prod-down             - Stop entire production environment (⚠️ dangerous in prod)"
	@echo "  prod-build            - Rebuild entire production image (⚠️ rarely needed in prod)"
	@echo "  prod-logs             - View production logs"
	@echo "  prod-shell            - Open shell in production container"
	@echo "  restart-gateway       - 🔁 Restart just the Caddy gateway (safe for prod CI/CD)"
	@echo "  deploy-webapp         - 🔁 Rebuild + restart just the webapp service (safe for prod CI/CD)"
	@echo "  restart-prod-services - ♻️ Restart all production services without removing containers"
	@echo "  ps                    - List running containers"
	@echo "  clean                 - Dangerously clean everything (🧨 use with care)"
	@echo "  help                  - Show this help message"

remind-me:
	@echo ""
	@echo "🧠 REMINDER: When to use each Make command"
	@echo ""
	@echo "# === DEV ==="
	@echo "  dev-up         - Start dev env (UI + API)"
	@echo "  dev-down       - Stop dev env"
	@echo "  dev-build      - Build dev images after changes"
	@echo "  dev-logs       - View live dev logs"
	@echo "  dev-shell      - Shell into dev webapp"
	@echo ""
	@echo "# === PROD ⚠️ Use with care ==="
	@echo "  prod-up        - [⚠️ RARE] Start full prod stack"
	@echo "  prod-down      - [🛑 DANGEROUS] Stop all prod containers"
	@echo "  prod-build     - [⚠️ RARE] Force full rebuild"
	@echo "  prod-logs      - View prod logs"
	@echo "  prod-shell     - Shell into prod webapp"
	@echo ""
	@echo "# === CI/CD SAFE ✅ ==="
	@echo "  deploy-webapp  - Rebuild + restart webapp only"
	@echo "  restart-gateway- Restart only Caddy"
	@echo "  restart-prod-services - Restart all prod services (no rebuild)"
	@echo ""
	@echo "# === UTILITIES ==="
	@echo "  ps             - List running containers"
	@echo "  clean          - [🧨 DANGEROUS] Full teardown of dev/prod"
	@echo "  help           - Show full command descriptions"
	@echo ""