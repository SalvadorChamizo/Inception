all:
	mkdir -p ~/data
	mkdir -p ~/data/mariadb ~/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up --build

stop:
	docker compose -f ./srcs/docker-compose.yml down

re: stop all

mariadb:
	docker exec -it mariadb-container /bin/bash

wordpress:
	docker exec -it wordpress-container /bin/bash

nginx:
	docker exec -it nginx-container /bin/bash

clean:
	docker volume rm database wordpress

.PHONY: stop clean re all