
init: ## init project
	@$(MAKE) down
	@docker-compose run --rm web rm -rf vendor
	@$(MAKE) composer-install
	@docker-compose up -d --build


down: ## down containers and remove them
	@docker-compose down -v

start: ## start containers
	@docker-compose start

stop: ## stop containers
	@docker-compose stop

restart: ## restart containers
	@$(MAKE) stop
	@$(MAKE) start

run: ## run shell
	@docker-compose exec web bash

composer-install: ## install composer deps
	@docker-compose run --rm web composer install

cache-clear:
	@docker-compose run --rm web php bin/console cache:clear
