-include .env

export

.PHONY: clean-docker
clean-docker:
	docker-compose down --rmi all -v --remove-orphans

.PHONY: start-docker
start-docker:
	docker-compose up

.PHONY: push-auth-server
push-auth-server:
	bash scripts/auth-service.sh upload

.PHONY: connect-ec2
connect-ec2:
	bash scripts/connect-ec2.sh $(instance)

.PHONY: copy-file
copy-file:
	scp -i ${KEY_PAIR} $(file) ec2-user@$(instance):~/.