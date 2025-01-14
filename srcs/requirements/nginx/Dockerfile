FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install nginx -y && apt install openssl -y

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=ES/ST=Andalucia/L=Malaga/O=42/OU=42/CN=schamizo.42.fr/UID=schamizo"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]