#!/bin/bash

prompt_with_loop()
{
    local prompt_message=$1
    local input

    while true; do
        printf "%s " "$prompt_message" >&2
        read -sp " " input
        echo >&2
        if [ -z "$input" ]; then
            echo "This field cannot be empty. Please try again." >&2
        else
            break
        fi
    done

    echo "$input"
}

ENV_FILE=".env"

read -p "Enter SQL database name: (default: my_database) " SQL_DATABASE
SQL_DATABASE=${SQL_DATABASE:-my_database}

read -p "Enter SQL user: (default: schamizo) " SQL_USER
SQL_USER=${SQL_USER:-schamizo}

SQL_PASSWORD=$(prompt_with_loop "Enter SQL password: ")

SQL_ROOT_PASSWORD=$(prompt_with_loop "Enter SQL root password: ")

read -p "Enter WordPress title (default: schamizo): " WP_TITLE
WP_TITLE=${WP_TITLE:-schamizo}

read -p "Enter WordPress admin username (default: schamizo): " WP_ADMIN_USR
WP_ADMIN_USR=${WP_ADMIN_USR:-schamizo}

WP_ADMIN_PWD=$(prompt_with_loop "Enter WordPress admin password: ")

read -p "Enter WordPress admin email (default: schamizo@student.42malaga.com)" WP_ADMIN_EMAIL
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-schamizo@student.42malaga.com}

read -p "Enter WordPress username (default: salva): " WP_USR
WP_USR=${WP_USR:-salva}

WP_EMAIL=$(prompt_with_loop "Enter WordPress user email :")

WP_PWD=$(prompt_with_loop "Enter WordPress user password: ")

WP_URL=${WP_URL:https://-schamizo.42.fr}

cat <<EOL > $ENV_FILE
SQL_DATABASE=$SQL_DATABASE
SQL_USER=$SQL_USER
SQL_PASSWORD=$SQL_PASSWORD
SQL_ROOT_PASSWORD=$SQL_ROOT_PASSWORD
WP_URL=$WP_URL
WP_TITLE=$WP_TITLE
WP_ADMIN_USR=$WP_ADMIN_USR
WP_ADMIN_PWD=$WP_ADMIN_PWD
WP_ADMIN_EMAIL=$WP_ADMIN_EMAIL
WP_USR=$WP_USR
WP_EMAIL=$WP_EMAIL
WP_PWD=$WP_PWD
EOL
