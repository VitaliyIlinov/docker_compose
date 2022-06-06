# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

include .env

CURRENT_UID=$(shell id -u)
CURRENT_GID=$(shell id -g)

ARGS = $(filter-out $@,$(MAKECMDGOALS))
MYSQL_DUMP=dumps/dump.sql

.SILENT: ;               # no need for @
.EXPORT_ALL_VARIABLES: ; # send all vars to shell

default: help

build : ## Build docker images
	docker-compose build --force-rm

code-sniff: ## Checking the standard code
	echo "vendor/bin/phpcs $(git diff --name-status [CURRENT_BRANCH] | grep '\.php$' | grep -v "^[RD]" | awk '{ print $2 }')"
	docker-compose exec -T app ./vendor/bin/phpcs ./${ARGS}

lint: ## Checking the standard code
	find . -name '*.php' -exec php -l {} \; | grep "error:"

up: ## Create and start containers in the background
	docker-compose up -d

down: ## Remove docker containers
	docker-compose down

composer-install: up ## Install php dependencies
	docker-compose exec -T app composer install

bash: ## Enter in container
	docker-compose exec app bash

logs: ## Show container logs
	docker-compose logs $(ARGS)

config: ## Show docker config
	docker-compose config

clean: ## Clean App logs chmod -R 777 storage/
	find storage -name "*.log" -delete

mysql-dump: ## Create backup of all databases
	docker exec db mysqldump --extended-insert=FALSE -u"$(DB_USERNAME)" -p"$(DB_PASSWORD)" $(DB_DATABASE) > "$(MYSQL_DUMP)"

mysql-restore: ## Restore backup of all databases
	docker exec -i db mysql -u"$(DB_USERNAME)" -p"$(DB_PASSWORD)" $(DB_DATABASE) < $(MYSQL_DUMP)
