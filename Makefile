all:
	@mkdir -p ~/data
	@mkdir -p ~/data/database ~/data/wordpress
	@docker compose -f ./srcs/docker-compose.yml up -d --build
	@echo "Inception is running"

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
	docker volume rm DataBase WordPress

recreate:
	docker compose -f ./srcs/docker-compose.yml up -d --build --force-recreate

.PHONY: stop clean re all
