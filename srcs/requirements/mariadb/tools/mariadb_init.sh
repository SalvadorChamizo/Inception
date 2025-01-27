#!/bin/sh

touch setup.sql
mkdir -p /run/mysqld
mkdir -p /var/run/mysqld

echo "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};" >> setup.sql
echo "CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';" >> setup.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';" >> setup.sql
echo "GRANT ALL PRIVILEGES ON *.* TO '${SQL_USER}'@'%';" >> setup.sql
echo "FLUSH PRIVILEGES;" >> setup.sql

chmod 777 setup.sql
mv setup.sql /run/mysqld/setup.sql
chown -R mysql:root /var/run/mysqld
# service mariadb start
mariadbd --init-file /run/mysqld/setup.sql
# mysql -u $DB_USER -p $DB_PASSWD < /run/mysqld/setup.sql