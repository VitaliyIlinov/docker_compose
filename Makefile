#  Makefile for Docker Nginx PHP Composer MySQL

include .env

CURRENT_UID=$(shell id -u)
CURRENT_GID=$(shell id -g)

ARGS = $(filter-out $@,$(MAKECMDGOALS))
MYSQL_DUMP=dumps/dump.sql

.SILENT: ;               # no need for @
.EXPORT_ALL_VARIABLES: ; # send all vars to shell

default: help

check:
ifeq ($(APP_NAME),)
	$(error Missed APP_NAME argument.)
endif

build : check
	@echo "build..."
	 docker-compose build --force-rm

code-sniff:
	echo "Checking the standard code..."
	echo "vendor/bin/phpcs $(git diff --name-status [CURRENT_BRANCH] | grep '\.php$' | grep -v "^[RD]" | awk '{ print $2 }')"
	docker-compose exec -T app ./vendor/bin/phpcs ./${ARGS}

up:
	docker-compose up -d

down:
	@docker-compose down

composer:
	@docker-compose exec -T app composer install

bash:
	@docker-compose exec app bash

logs:
	@docker-compose logs $(ARGS)

config:
	@docker-compose config

clean: #chmod -R 777 storage/
	@find storage -name "*.log" -delete

mysql-dump:
	@docker exec db mysqldump --extended-insert=FALSE -u"$(DB_USERNAME)" -p"$(DB_PASSWORD)" $(DB_DATABASE) > "$(MYSQL_DUMP)"

mysql-restore:
	@docker exec -i db mysql -u"$(DB_USERNAME)" -p"$(DB_PASSWORD)" $(DB_DATABASE) < $(MYSQL_DUMP)

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo ' - build         Build docker images'
	@echo ' - up            Create and start containers'
	@echo ' - bash          Enter in container'
	@echo ' - logs [NAME]   Show container logs'
	@echo ' - clean         Clean App logs'
	@echo ' - mysql-dump    Create backup of all databases'
	@echo ' - mysql-restore Restore backup of all databases'
	@echo ' - up            Create and start containers in the background'
	@echo ' - down          Stop and remove containers, networks, images, and volumes'
	@echo ' - composer      Bash to container & Install composer and npm'
	@echo ' - help          Show this help and exit'
