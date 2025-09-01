# LocalStack
The project is used for development environment as an emulation of K8s services.

List of services:
* [Mysql](https://hub.docker.com/_/mysql)

## First launch
1. Rename `.env.example` to `.env`
2. Edit `.env` to meet your needs
3. Run `make start`

## Update MySQL version
Before updating Production RDS MySQL version, it must be updated and tested locally. Production and local versions and configs must be always the same.
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
