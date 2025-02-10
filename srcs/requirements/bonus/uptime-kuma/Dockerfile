FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install git nodejs npm -y

RUN git clone https://github.com/louislam/uptime-kuma.git

RUN npm install

EXPOSE 3001

CMD ["node", "server/server.js"]