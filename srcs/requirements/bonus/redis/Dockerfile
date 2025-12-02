FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install redis -y

COPY ./tools/redis_init.sh /

EXPOSE 6379

CMD ["sh", "redis_init.sh"]
