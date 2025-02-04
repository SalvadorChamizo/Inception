FROM debian:bullseye

RUN apt update -y && apt install -y

RUN apt install vsftpd -y

COPY ./ftp_init.sh /

CMD ["sh", "ftp_init.sh"]
