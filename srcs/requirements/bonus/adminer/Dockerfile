FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install -y php php-cli php-mbstring php-mysql php-fpm wget
# php -> Core PHP package required to run Admirer.
# php-cli -> Needed to run PHP commands in a container.
# php-mbstring -> Required for working with non-English characters.
# php-mysql -> It enables PHP to communicate with MySQL/MariaDB databases.

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O index.php


RUN mkdir -p /var/www/html && mv index.php /var/www/html/

COPY ./tools/adminer_init.sh /
COPY ./conf/www.conf /

EXPOSE 9000

CMD ["bash", "adminer_init.sh"]
