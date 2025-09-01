CREATE USER 'php_not_dead'@'%' IDENTIFIED WITH mysql_native_password BY 'password';

CREATE DATABASE IF NOT EXISTS cto_for_sale;
GRANT ALL PRIVILEGES ON cto_for_sale.* TO 'php_not_dead'@'%';

FLUSH PRIVILEGES;
