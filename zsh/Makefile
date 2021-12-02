.PHONY: $(filter-out vendor, $(MAKECMDGOALS))
.DEFAULT_GOAL := help

help:
	@echo "\033[33mUsage:\033[0m\n  make [target] [arg=\"val\"...]\n\n\033[33mTargets:\033[0m"
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | uniq | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-25s\033[0m %s\n", $$1, $$2}'

build: ## Build the docker image
	docker build . -t zsh-setup:latest

run: ## Spin up the built image
	docker run -it zsh-setup:latest