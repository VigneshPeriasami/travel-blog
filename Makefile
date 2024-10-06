
AUTH_SERVER_DOCKER_COMPOSE = js/docker-compose.yml
BACKEND_SERVER_DOCKER_COMPOSE = backend-server/docker-compose.yml
AUTH_GATEWAY_DOCKER_COMPOSE = auth-sidecar/docker-compose.yml 

.PHONY: clean-docker
clean-docker:
	docker compose down --rmi all -v --remove-orphans

.PHONY: start-docker
start-docker:
	docker compose up --pull=never

prepare-docker:
	docker compose -f $(docker_compose_file_path) build

push-docker:
	docker compose -f $(docker_compose_file_path) build --push

.PHONY: prepare-authserver-image
prepare-authserver-image: docker_compose_file_path=$(AUTH_SERVER_DOCKER_COMPOSE)
prepare-authserver-image: prepare-docker

.PHONY: push-authserver-image
push-authserver-image: docker_compose_file_path=$(AUTH_SERVER_DOCKER_COMPOSE)
push-authserver-image: push-docker

.PHONY: push-backendserver-image
push-backendserver-image: docker_compose_file_path=$(BACKEND_SERVER_DOCKER_COMPOSE)
push-backendserver-image: push-docker

.PHONY: push-authgateway-image
push-authgateway-image: docker_compose_file_path=$(AUTH_GATEWAY_DOCKER_COMPOSE)
push-authgateway-image: push-docker

build-server-ami:
	packer build -var-file=$(ami_arg_file_path) packer/webserver.pkr.hcl

.PHONY: build-authserver-ami
build-authserver-ami: ami_arg_file_path=packer/auth-server.pkrvars.hcl
build-authserver-ami: push-authserver-image build-server-ami

.PHONY: build-backendserver-ami
build-backendserver-ami: ami_arg_file_path=packer/backend-server.pkrvars.hcl
build-backendserver-ami: push-backendserver-image build-server-ami

