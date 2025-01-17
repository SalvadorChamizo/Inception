FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install wget -y && apt install tar -y

RUN apt install -y php-fpm php-mysql
# php-fpm: Handles PHP requests for the web server. Also it installs the
# latest PHP version available.
# php-mysql: To connect to MariaDB database.

RUN mkdir -p /var/www/html
# -p means parent directory, if /var or /www doesn't exist, they will be created

RUN wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
# wget is a command-line utility used to download files from the internet.
# -O specifies the output file path where the downloaded file will be saved.

RUN tar -xzf /tmp/wordpress.tar.gz -C /var/www/html && rm /tmp/wordpress.tar.gz
# tar is a command-line tool used to extract and manipulate archve files.
# -x extracts files from an archive.
# -z indicates that the archive is compressed with gzip for .tar.gz files.
# -f specifies the filename of the archive to be extracted.
# -C specifies the target directory where the extracted files will be placed.


RUN apt install -y mariadb-client