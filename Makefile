start:
	./builders/build_mysql.sh
	docker-compose up -d

stop:
	docker-compose down

db-restore:
	./builders/build_mysql.sh --rebuild=1
	sudo docker volume rm localstack_mysql

list:
	docker-compose ps

list-all:
	docker ps -a

mysql:
	docker-compose exec mysql bash

redis:
	docker-compose exec redis redis-cli

rabbitmq:
	docker-compose exec rabbitmq bash
