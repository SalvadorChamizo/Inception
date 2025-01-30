#!/bin/bash

# This script must be executed with bash

# Function used to ask for input without show the keys pressed
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

# With this I only have to change the name once if I want to execute Inception with other user.
INCEPTION_USER="schamizo"

# This variable sets the wordpress username
NAME_USER="salva"

# Name for the file to be created.
ENV_FILE=".env"


# Name for the database
read -p "Enter SQL database name: (default: my_database) " SQL_DATABASE
SQL_DATABASE=${SQL_DATABASE:-my_database}

# User for SQL
read -p "Enter SQL user: (default: $INCEPTION_USER) " SQL_USER
SQL_USER=${SQL_USER:-$INCEPTION_USER}

# Password for SQL
SQL_PASSWORD=$(prompt_with_loop "Enter SQL password: ")

# Root password for SQL
SQL_ROOT_PASSWORD=$(prompt_with_loop "Enter SQL root password: ")

# Title for the wordpress's site
read -p "Enter WordPress title (default: $INCEPTION_USER): " WP_TITLE
WP_TITLE=${WP_TITLE:-$INCEPTION_USER}

# Admin username for Wordpress
read -p "Enter WordPress admin username (default: $INCEPTION_USER): " WP_ADMIN_USR
WP_ADMIN_USR=${WP_ADMIN_USR:-$INCEPTION_USER}

# Admin password for Wordpress
WP_ADMIN_PWD=$(prompt_with_loop "Enter WordPress admin password: ")

# Admin email for Wordpress
read -p "Enter WordPress admin email (default: $INCEPTION_USER@student.42malaga.com)" WP_ADMIN_EMAIL
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-$INCEPTION_USER@student.42malaga.com}

# Username for Wordpress
read -p "Enter WordPress username (default: $NAME_USER): " WP_USR
WP_USR=${WP_USR:-$NAME_USER}

# User email for Wordpress
WP_EMAIL=$(prompt_with_loop "Enter WordPress user email :")

# User password for Wordpress
WP_PWD=$(prompt_with_loop "Enter WordPress user password: ")

# WordPress URL
WP_URL=${WP_URL:-$INCEPTION_USER.42.fr}

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
WORDPRESS_DATA_LOCATION="/home/$INCEPTION_USER/data/wordpress"
MARIABD_DATA_LOCATION="/home/$INCEPTION_USER/data/database"
EOL
