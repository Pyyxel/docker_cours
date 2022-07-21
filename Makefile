help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## init project
	@$(MAKE) down
	@docker-compose run --rm web rm -rf vendor
	@$(MAKE) composer-install
	@docker-compose up -d --build
	@$(MAKE) reset-database

down: ## down containers and remove them
	@docker-compose down -v

start: ## start containers
	@docker-compose start

stop: ## stop containers
	@docker-compose stop

restart: ## restart containers
	@$(MAKE) stop
	@$(MAKE) start

shell: ## run shell
	@docker-compose exec web bash

composer-install: ## install composer deps
	@docker-compose run --rm web composer install

reset-database:
	@docker-compose run --rm web php bin/console doctrine:schema:drop -f
	@docker-compose run --rm web php bin/console doctrine:schema:create
	@$(MAKE) load-fixtures

load-fixtures: ## load fixtures
	@docker-compose run --rm web php bin/console doctrine:fixtures:load -n

cache-clear:
	@docker-compose run --rm web php bin/console cache:clear

test:
	@docker-compose -p magmi-copilot-test -f docker-compose.test.yml up -d
	@docker-compose exec -T web ./docker/wait-for-it.sh --timeout=120 db_test:3306
	@docker-compose exec web php bin/console doctrine:schema:create --env=test
	@docker-compose exec web vendor/bin/phpunit $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)) --verbose --colors=always --testdox || true
	@docker-compose -p magmi-copilot-test -f docker-compose.test.yml down -v