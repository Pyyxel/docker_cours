
init: ## init project
	@$(MAKE) down
	@docker-compose run --rm web rm -rf vendor
	@docker-compose up -d --build
	@$(MAKE) composer-install
	@docker-compose run --rm web php bin/console make:migration
	@$(MAKE) resetdb

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

resetdb:
	@docker-compose run --rm web symfony console d:d:d --force 
	@docker-compose run --rm web symfony console d:d:c
	@docker-compose run --rm web symfony console d:m:m