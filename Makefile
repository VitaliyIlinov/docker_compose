default: help

help:
	@echo 'Targets:'
	@echo ' - build         Build docker images'
	@echo ' - up            Create and start containers'
	@echo ' - up-d          Create and start containers in the background'
	@echo ' - down          Stop and remove containers, networks, images, and volumes'
	@echo ' - help          Show this help and exit'

.PHONY: build
build:
	docker-compose build

.PHONY: up
up:
	docker-compose up

.PHONY: up-d
up-d:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: stop
stop:
	docker-compose stop

.PHONY: bash
bash: up-d
	docker-compose exec php bash

.PHONY: del
del:
	@docker container rm $(shell docker ps -aq) -f
