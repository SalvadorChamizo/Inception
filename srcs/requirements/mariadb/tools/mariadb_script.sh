#!/bin/bash

exit_flag=false

# Ensure each environment variable is set

if [-z "$SQL_DATABASE"]; then
    echo "ERROR: Environment variable SQL_DATABASE is not set."
    exit_flag=true
fi

if [-z "$SQL_USER"]; then 
    echo "ERROR: Environment variable SQL_USER is not set."
    exit_flag=true
fi

if [-z "$SQL_PASSWORD"]; then
    echo "ERROR: Environment variable SQL_PASSWORD is not set."
    exit_flag=true
fi

if [-z "$SQL_ROOT_PASSWORD"]; then
    echo "ERROR: Environment variable SQL_ROOT_PASSWORD is not set."
    exit_flag=true
fi

if ["$exit_flag" = true]; then
    exit 1
fi

# Start MariaDB service
service mariadb start;

# Create database if it doesn't exist
mysql -e "CREATE DATABASE IF NOT EXISTS \'$SQL_DATABASE\';"

# Create user if it doesn't exist
mysql -e "CREATE USER IF NOT EXISTS \'$SQL_USER\'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

# Grant all privileges to the user on the specified database
mysql -e "GRANT ALL PRIVILEGES ON \'$SQL_DATABASE\'.* TO \'$SQL_USER\'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Change the root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"

# Restart privileges to apply changes
mysql -e "FLUSH PRIVILEGES;"

# Shutdown MySQL to ensure proper initialization
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

service mariadb stop;

# Start MariaDB using mysqld (preferred for container environment)
exec mysqld_safe
