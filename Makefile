.DEFAULT_GOAL := help

APPLICATION?=tools-kit
COMMIT_SHA?=$(shell git rev-parse --short HEAD)
DOCKER?=docker
REGISTRY?=jonascheng

.PHONY: docker-login
docker-login: ## login docker registry
ifndef DOCKERHUB_USERNAME
	$(error DOCKERHUB_USERNAME not set on env)
endif
ifndef DOCKERHUB_PASSWORD
	$(error DOCKERHUB_PASSWORD not set on env)
endif
	${DOCKER} login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD}

.PHONY: docker-build-release
docker-build-release: ## build docker image without cache (slower than make docker-build)
	${DOCKER} build --pull --no-cache -t ${REGISTRY}/${APPLICATION}:${COMMIT_SHA} .

.PHONY: docker-push
docker-push: docker-build-release docker-login ## push the docker image to registry
	${DOCKER} tag ${REGISTRY}/${APPLICATION}:${COMMIT_SHA} ${REGISTRY}/${APPLICATION}:latest
	${DOCKER} push ${REGISTRY}/${APPLICATION}:${COMMIT_SHA}
	${DOCKER} push ${REGISTRY}/${APPLICATION}:latest

.PHONY: help
help: ## prints this help message
	@echo "Usage: \n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
