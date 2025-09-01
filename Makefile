start:
	docker-compose up -d

stop:
	docker-compose down

db-restore:
	sudo docker volume rm localstack_mysql

list:
	docker-compose ps

list-all:
	docker ps -a

mysql:
	docker-compose exec mysql bash
