PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;")

mkdir -p /run/php

mv ./www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

#sed -i "s|listen = /run/php/php${PHP_VERSION}-fpm.sock|listen = 9000|g" etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

php-fpm${PHP_VERSION} -F
