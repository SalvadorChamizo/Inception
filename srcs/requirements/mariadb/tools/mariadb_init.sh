#!/bin/sh

# Creates a file in which I will write all the commands needed to start mariadb
touch init.sql

mkdir -p /run/mysqld
mkdir -p /var/run/mysqld

# Create the database if it doesn't exist
echo "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};" >> init.sql

# Create the user if it doesn't exist
echo "CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';" >> init.sql

# Change the root password
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';" >> init.sql

# Grant all privileges to the user on the specified database
echo "GRANT ALL PRIVILEGES ON *.* TO '${SQL_USER}'@'%';" >> init.sql

# Apply privilege changes
echo "FLUSH PRIVILEGES;" >> init.sql

chmod 777 init.sql
mv init.sql /run/mysqld/init.sql
chown -R mysql:root /var/run/mysqld

# This is the MariaDB database server daemon (background)
mariadbd --init-file /run/mysqld/init.sql
# --init-file -> Tells MariaDB to execute SQL commands from the file init.sql
