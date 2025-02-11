FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install git curl npm -y

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

RUN apt install nodejs -y

RUN git clone https://github.com/louislam/uptime-kuma.git

WORKDIR /uptime-kuma

RUN npm install
RUN npm run build

RUN npm install pm2 -g && pm2 install pm2-logrotate

EXPOSE 3001

CMD ["pm2-runtime", "start", "server/server.js", "--name", "uptime-kuma"]
