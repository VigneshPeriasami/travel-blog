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

.PHONY: connect-mysql-ec2
connect-mysql-ec2:
	ssh -i ${KEY_PAIR} ${MYSQL_EC2}
