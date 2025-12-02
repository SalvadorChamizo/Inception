FROM debian:bullseye

RUN apt update -y && apt install -y

RUN apt install vsftpd -y

COPY ./tools/ftp_init.sh /

CMD ["sh", "ftp_init.sh"]
