include .env
IMAGE_NAME = app
BUILD_ID ?= $(shell /bin/date "+%Y%m%d-%H%M%S")
ARGS = $(filter-out $@,$(MAKECMDGOALS))

E ?= ternarniy operator

default: help

test: foo:=7.2
test: foo1:=nginx
test:$(foo) $(foo1)
	#echo $(E)
	#echo $(ARGS)
	#echo $(foo)
	#echo $(foo1)
ifneq ($(foo),)
	@echo "with foo"
else
	@echo "without foo"
endif

.PHONY: code-sniff
code-sniff:
	@echo "Checking the standard code..."
	@docker-compose exec -T php ./app/vendor/bin/phpcs -v --standard=PSR2 app

.PHONY: logs
logs:
	@docker-compose logs -f

.PHONY: build
build: SOME_TEST:=test
build:
	@echo "build..."
	 docker build \
  	--build-arg SOME_TEST=$(SOME_TEST) \
 	--force-rm  \
 	--no-cache \
 	-t $(IMAGE_NAME) .

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: stop
stop:
	docker-compose stop

.PHONY: bash
bash: bash
	docker-compose exec $(IMAGE_NAME) bash

.PHONY: del
del:
	@docker container rm $(shell docker ps -aq) -f

help:
	@echo 'Targets:'
	@echo ' - build         Build docker images'
	@echo ' - up            Create and start containers'
	@echo ' - up-d          Create and start containers in the background'
	@echo ' - down          Stop and remove containers, networks, images, and volumes'
	@echo ' - help          Show this help and exit'
