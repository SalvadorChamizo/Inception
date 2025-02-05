#!/bin/bash

# Get the installed PHP version (e.g., "7.4") in case there is a PHP \
# update in the future. 
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;")

# Creates the directory if it doesn't exist.
# This directory is used to store runtime files like PHP-FPM socket.
mkdir -p /run/php
# If this directory doesn't exists, PHP-FPM won't be able to create \
# or access the required socket file, leading to errors.

# This command ensures that the web server (running as www-data) \
# has the necessary ownership to read, write, and execute the \
# WordPress files.
chown -R www-data.www-data /var/www/
# chown -> Changes the ownership of files and directories.
# -R -> Recursively applies the ownership change to all files
# www-data.www-data -> The first specifies the user, the second the group.
# /var/www/html/wordpress -> The directory where the WordPress \
# files are located.

# This command define what actions (read, write, execute) can be \
# performed by the owner, group and others.
chmod -R 755 /var/www/
# 7 -> The owner has full permissions.
# 5 -> The group and others can read and execute, but not write.

# This command is used to modify the PHP-FPM configuration file www.conf.
# The default PHP-FPM configuration uses a Unix socket for communication.
# The new configuration specifies that PHP-FPM should listen on wordpress:9000.
sed -i "s#listen = /run/php/php${PHP_VERSION}-fpm.sock#listen = wordpress:9000#g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
# sed -> A stream editor used to perform text transformations on a file.
# -i -> This flag makes sed directly modify the file instead of printing \
# the changes to the terminal.
# s# -> Substitution command. It replaces text that matches a pattern.
# # -> Delimiter. It's used to separate the search pattern and the replacement text.
# g -> Global flag. It ensures that all matches in a line are replaced.

### IMPORTANT

# From here there are three possible solutions in order to configure WordPress.

# - You can rename the wp-config-sample.php to wp-config.php and modify it manually with "sed -i"

# - You can install wp-cli to create the wp-config.php with commands.

# - You can write a wp-config.php and COPY it with the dockerfile inside the container.

# But you will need to install wp-cli anyway for the WordPress installation, and it's the most \
# efficient tool in most cases for managing WordPress in scripts, so I will choose the second option.

###

# WP-CLI is a command-line interface for managing WordPress installations.
# It allows you to perform a wide range of administrative tasks without \
# needing to interact with the WordPress web dashboard.

# We will download wp-cli in the /usr/local/bin directory, the place \
# where applications that not came from Linux should go.
cd /usr/local/bin

# We will download it from the Github repository.
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# A .phar file is a type of compressed file used to package PHP applications or \
# libraries into a single executable file.

# We will change the name of the file
mv wp-cli.phar wp

# Change the permission to execute it
chmod +x wp

# We will go to the directory where the wp-config.php should be.
cd /var/www/html/wordpress

# This command will create the wp-config.php file with our custom configuration.
wp config create --allow-root   --dbname=$SQL_DATABASE \
                                --dbuser=$SQL_USER \
                                --dbpass=$SQL_PASSWORD \
                                --dbhost=mariadb:3306 \
				--url=$WP_URL \
                                --path='/var/www/html/wordpress'
# wp config create -> Command to create the wp-config.php
# --allow-root -> Flag to create it as root. If not set, there is an error message.
# --dbname= -> Indicate the name of the database.
# --dbuser= -> User for the database.
# --dbpass= -> Pass for the database.
# --dbhost= -> Indicates where the database is.
# --path= -> Path where the wp-config.php will be created.

###            BONUS PART: REDIS              ###

#Modify the wp-config.php to add Redis
wp config set WP_REDIS_HOST 'redis' --raw --allow-root
wp config set WP_REDIS_PORT 6379 --raw --allow-root
wp config set WP_CACHE true --raw --allow-root
wp config set WP_CACHE_KEY_SALT 'mywordpresssite_' --raw --allow-root
wp config set WP_REDIS_CLIENT 'phpredis' --raw --allow-root
# WP_REDIS_HOST -> Define the Redis Host (container name for Redis service)
# WP_REDIS_PORT -> Define the Redis Port (default 6379)
# WP_CACHE -> Enable WordPress Object Cache
# WP_CACHE_KEY_SALT (Recommended) -> This adds a prefix to all cache keys to avoid conflicts if multiple \
# WordPress installations share the same Redis server.
# WP_REDIS_CLIENT (Optional) -> This tells WordPress to use phpredis instead of Predis, which is slower.
# --raw -> This prevents WordPress from wrapping values in quotes (true instead of 'true')

# Install and activate Redis Object Cache Plugin
wp plugin install redis-cache --activate --allow-root
# install redis-cache -> Installs the Redis Object Cache Plugin
# --activate -> Automatically activates the plugin after installation

# (Optional but Recommended)
wp plugin update --all --allow-root
# Ensures all plugins are updated to the latest version

# Enable Redis Cache in WordPress
wp redis enable --allow-root

###           END OF REDIS PART          ###

# Command to install WordPress with the initial site configuration.
wp core install --allow-root    --url=$WP_URL \
                                --title=$WP_TITLE \
                                --admin_user=$WP_ADMIN_USR \
                                --admin_password=$WP_ADMIN_PWD \
                                --admin_email=$WP_ADMIN_EMAIL \
                                --skip-email \
                                --locale=es_ES \
			        --path='/var/www/html/wordpress'
# wp core install -> Command to run the WordPress core installation process.
# --url= -> Specifies the site URL for the WordPress installation.
# --title= -> Sets the title of the WordPress site.
# --skip-email -> Skips sending the notification email to the admin user.
# --locale=es_Es -> Sets the language for the WordPress installation to Spanish.

# Now we will create a new user with security porpuses, because it's \
# not secure to have only an admin and do every task with it.
wp user create $WP_USR $WP_EMAIL --role=author \
                                 --user_pass=$WP_PWD \
                                 --allow-root
# wp user create -> Command to create a new WordPress user.
# --role=author -> Specifies the role of the new user. Author can publish and manage their own posts.
# Now I will use a command to run the PHP-FPM process in the foreground.
php-fpm${PHP_VERSION} -F
# This is because containers are designed to keep running as long as \
# their main process is active. Running php-fpm in the background \
# will stop the container because Docker assumes the process has exited.

# PHP-FPM is responsible for handling PHP requests, such as rendering \
# WordPress pages.
# Without this, your web server (Nginx) cannot process PHP files \
# and will serve an error.
