.PHONY: dev-up dev-down dev-build dev-logs dev-shell \
		prod-up prod-down prod-build prod-logs prod-shell \
		ps clean help

# Configurable variables
COMPOSE_DEV=docker-compose.development.yaml
COMPOSE_PROD=docker-compose.production.yaml

## ---------- Development ---------- ##

dev-up:
	@echo "Starting development environment..."
	@echo "Building development images..."
	docker-compose -f $(COMPOSE_DEV) up --build
	@echo "Development environment started successfully."

dev-down:
	@echo "Stopping development environment..."
	docker-compose -f $(COMPOSE_DEV) down
	@echo "Development environment stopped successfully."
	@echo "To clean up all containers and volumes, run 'make clean'."

dev-build:
	@echo "Building development images..."
	docker-compose -f $(COMPOSE_DEV) build
	@echo "Development images built successfully."
	@echo "To start the development environment, run 'make dev-up'."

dev-logs:
	@echo "Viewing development logs..."
	@echo "To stop the logs, press Ctrl+C."
	@echo "To open a shell in the web container, run 'make dev-shell'."
	docker-compose -f $(COMPOSE_DEV) logs -f


dev-shell:
	@echo "Opening shell in development web container..."
	@echo "To stop the shell, type 'exit'."
	docker-compose -f $(COMPOSE_DEV) exec web sh
	

## ---------- Production ---------- ##

prod-up:
	@echo "Starting production environment..."
	@echo "Building production images..."
	docker-compose -f $(COMPOSE_PROD) up --build -d
	@echo "Production environment started successfully."
	@echo "To view logs, run 'make prod-logs'."
	@echo "To open a shell in the web container, run 'make prod-shell'."

prod-down:
	@echo "Stopping production environment..."
	docker-compose -f $(COMPOSE_PROD) down
	@echo "Production environment stopped successfully."

prod-build:
	@echo "Building production images..."
	docker-compose -f $(COMPOSE_PROD) build --no-cache
	@echo "Production images built successfully."
	@echo "To start the production environment, run 'make prod-up'."

prod-logs:
	@echo "Viewing production logs..."
	@echo "To stop the logs, press Ctrl+C."
	@echo "To open a shell in the web container, run 'make prod-shell'."
	docker-compose -f $(COMPOSE_PROD) logs -f


prod-shell:
	@echo "Opening shell in production web container..."
	@echo "To stop the shell, type 'exit'."
	@echo "To view logs, run 'make prod-logs'."
	docker-compose -f $(COMPOSE_PROD) exec web sh


## ---------- Utility ---------- ##

ps:
	docker ps

clean:
	@echo "Cleaning up all containers and volumes..."
	docker-compose -f $(COMPOSE_DEV) down -v --remove-orphans
	docker-compose -f $(COMPOSE_PROD) down -v --remove-orphans
	docker system prune -f


help:
	@echo "Makefile commands:"
	@echo "  dev-up       - Start development environment"
	@echo "  dev-down     - Stop development environment"
	@echo "  dev-build    - Build development images"
	@echo "  dev-logs     - View development logs"
	@echo "  dev-shell    - Open shell in development container"
	@echo "  prod-up      - Start production environment"
	@echo "  prod-down    - Stop production environment"
	@echo "  prod-build   - Build production images"
	@echo "  prod-logs    - View production logs"
	@echo "  prod-shell   - Open shell in production container"
	@echo "  ps           - List running containers"
	@echo "  clean        - Clean up all containers and volumes"
	@echo "  help         - Show this help message"