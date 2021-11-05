include .env
ROOT_DIR   := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
IMAGE_NAME = $(APP_NAME)
BUILD_ID ?= $(shell /bin/date "+%Y%m%d-%H%M%S")
ARGS = $(filter-out $@,$(MAKECMDGOALS))
MYSQL_DUMP=dumps/dump.sql
USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

.SILENT: ;               # no need for @
.EXPORT_ALL_VARIABLES: ; # send all vars to shell

E ?= ternarniy operator
#VERSION ?= $(shell cat $(ROOT_DIR)/VERSION | head -n 1)
ifeq ($(VERSION),)
VERSION := 0.0.1
endif

default: help

test: foo:=7.4
test: foo1:=nginx
test:
	echo $(E)
	echo $(ARGS)
	echo $(foo)
	echo $(foo1)
ifneq ($(foo),)
	@echo "with foo"
else
	@echo "without foo: need global"
endif

check:
ifeq ($(APP_NAME),)
	$(error Missed APP_NAME argument.)
endif

build : check
	@echo "build..."
	 docker build \
  	--build-arg USER_ID=$(USER_ID) \
  	--build-arg GROUP_ID=$(GROUP_ID) \
 	--force-rm  \
 	--no-cache \
 	-t $(IMAGE_NAME) ./docker/

up:
	docker-compose up -d

down:
	@docker-compose down

dependency:
	@docker-compose exec $(APP_NAME) bash -c "php artisan storage:link && composer install && npm install && npm run dev && php artisan migrate:fresh --seed"

bash:
	@docker-compose exec $(APP_NAME) bash

logs:
	@docker-compose logs $(ARGS)

config:
	@docker-compose config

clean:
	@docker exec $(APP_NAME) rm -R ./storage/logs/*

mysql-dump:
	@docker exec db mysqldump --extended-insert=FALSE -u"$(DB_USERNAME)" -p"$(DB_PASSWORD)" $(DB_DATABASE) > "$(MYSQL_DUMP)"

mysql-restore:
	@docker exec -i db mysql -u"$(DB_USERNAME)" -p"$(DB_PASSWORD)" $(DB_DATABASE) < $(MYSQL_DUMP)

help:
	@echo 'Targets:'
	@echo ' - build         Build docker images'
	@echo ' - up            Create and start containers'
	@echo ' - bash          Enter in container'
	@echo ' - logs [NAME]   Show container logs'
	@echo ' - clean         Clean App logs'
	@echo ' - mysql-dump    Create backup of all databases'
	@echo ' - mysql-restore Restore backup of all databases'
	@echo ' - up-d          Create and start containers in the background'
	@echo ' - down          Stop and remove containers, networks, images, and volumes'
	@echo ' - help          Show this help and exit'
