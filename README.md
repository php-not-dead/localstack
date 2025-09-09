<img src="https://avatars.githubusercontent.com/u/70107733?s=128" width="100" alt="PHP not Dead">

PHP not Dead Development images
=============================

The is Docker images list used for development environment:
* [Mysql](https://hub.docker.com/_/mysql) 8.4.6
* [Redis](https://hub.docker.com/_/redis) 8.2.1
* [RabbitMQ](https://hub.docker.com/_/rabbitmq) 4.1.4 with [rabbitmq-delayed-message-exchange](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)

## First launch
1. Rename `.env.example` to `.env`
2. Edit `.env` to meet your needs
3. Run `make start`

## Update MySQL version
Before updating Production MySQL version, it must be updated and tested locally.
Production and local versions and configs must be always the same.
MySQL image must be saved in GitHub packages in case of global deprecation.
1. `docker pull mysql:8.4.6` - pull preferred version of MySQL
2. `docker tag mysql:8.4.6 ghcr.io/php-not-dead/mysql:8.4.6` - create `ghcr.io/php-not-dead` for new version
3. `docker push ghcr.io/php-not-dead/mysql:8.4.6`
4. Replace `docker-compose.yml` line `image: ghcr.io/php-not-dead/mysql:8.4.5` with proper version `image: ghcr.io/php-not-dead/mysql:8.4.6`
5. `make stop`
6. `make db-restore` - will TRUNCATE all schemas and data
7. `make start`
All historical MySQL images are stored here: https://github.com/php-not-dead/dockerfiles/pkgs/container/mysql

## Add/remove MySQL schema
1. Update `.build/mysql/init.sql` - add/remove database and grant all permissions to new schema
2. `make stop`
3. `make db-restore` - will TRUNCATE all schemas and data
4. `make start` - will create new list of schemas
5. All truncate schemas should be filled with data by API migrations and seeds

## Update Redis version
Before updating Production Redis version, it must be updated and tested locally.
Production and local versions and configs must be always the same.
Redis image must be saved in GitHub packages in case of global deprecation.
1. `docker pull redis:8.2.1` - pull preferred version of Redis
2. `docker tag redis:8.2.1 ghcr.io/php-not-dead/redis:8.2.1` - create `ghcr.io/php-not-dead` for new version
3. `docker push ghcr.io/php-not-dead/redis:8.2.1`
4. Replace `docker-compose.yml` line `image: ghcr.io/php-not-dead/redis:8.2.0` with proper version `image: ghcr.io/php-not-dead/redis:8.2.1`
5. `make stop`
6. `make start`
   All historical MySQL images are stored here: https://github.com/php-not-dead/dockerfiles/pkgs/container/redis

## Update RabbitMQ version
Before updating Production RabbitMQ version, it must be updated and tested locally. Production and local versions and configs must be always the same.
RabbitMQ image must be saved in GitHub packages in case of global deprecation.
1. `docker pull rabbitmq:4.1.4` - pull preferred version of RabbitMQ
2. `docker tag rabbitmq:4.1.4-management ghcr.io/php-not-dead/rabbitmq:4.1.4` - create `ghcr.io/php-not-dead` for new version
3. `docker push ghcr.io/php-not-dead/rabbitmq:4.1.4`
4. Replace `docker-compose.yml` line `image: ghcr.io/php-not-dead/rabbitmq:4.1.3` with proper version `image: ghcr.io/php-not-dead/rabbitmq:4.1.4`
5. Download proper `rabbitmq-delayed-message-exchange` version from https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases
6. Replace `docker-compose.yml` `rabbitmq.volumes` plugin file
7. Update `./.build/rabbitmq/definitions.json` versions
8. Ensure, that `.build/rabbitmq/enabled_plugins` match production `> rabbitmq-plugins list` enabled plugins list
9. `make stop`
10. `make start`

## Add RabbitMQ vhost
1. Update `.build/rabbitmq/definitions.json` - add/remove vhost to `vhosts` and `permissions`
2. `make stop`
3. `make start`
