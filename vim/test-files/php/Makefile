.PHONY: $(filter-out vendor, $(MAKECMDGOALS))
.DEFAULT_GOAL := help

USER_ID=$(shell id -u ${USER})
GROUP_ID=$(shell id -g ${USER})

help:
	@echo "\033[33mUsage:\033[0m\n  make [target] [arg=\"val\"...]\n\n\033[33mTargets:\033[0m"
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | uniq | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-8s\033[0m %s\n", $$1, $$2}'

build: ## Build the docker image
	docker build \
		--build-arg USER=${USER} \
		--build-arg UID=${USER_ID} \
		-t vim-php:latest \
		-f Dockerfile \
		.

run: ## Run it
	docker run \
		-v ${PWD}:/var/www/html/ \
		-p 34435:80 \
		--name vim-php-test \
		-d \
		vim-php:latest

stop: ## Restart Docker container
	docker stop vim-php-test
	docker rm vim-php-test
