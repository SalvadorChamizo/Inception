FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install redis -y

COPY ./tools/redis_init.sh /

CMD ["sh", "redis_init.sh"]