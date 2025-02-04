# Create the directories for the volumes if they don't exists. Runs docker compose in the background and rebuild images.
all:
	@mkdir -p ~/data
	@mkdir -p ~/data/database ~/data/wordpress
	@docker compose -f ./srcs/docker-compose.yml up -d --build
	@echo "Inception is running"

# Removes the containers and volumes. Running docker compose up again will create the containers from scratch.
down:
	docker compose -f ./srcs/docker-compose.yml down

re: stop all

# Access the mariadb container
mariadb:
	docker exec -it mariadb /bin/bash

# Access the wordpress container
wordpress:
	docker exec -it wordpress /bin/bash

# Access nginx container
nginx:
	docker exec -it nginx /bin/bash

# Access redis container
redis:
	docker exec -it redis /bin/bash

# Access adminer container
adminer:
	docker exec -ti adminer /bin/bash

# Access ftp-server container
ftp-server:
	docker exec -ti ftp-server /bin/bash

# Remove the volumes
clean:
	docker volume rm DataBase WordPress

# Remove everything
fclean:
	docker stop $$(docker ps -qa); docker rm $$(docker ps -qa); docker rmi -f $$(docker images -qa); docker volume rm $$(docker volume ls -q); docker network rm $$(docker network ls -q) 2>/dev/null

fclean_cache:
	docker system prune -a --volumes

# Run docker compose in the background and rebuild images and containers.
recreate:
	docker compose -f ./srcs/docker-compose.yml up -d --build --force-recreate

.PHONY: stop clean re all
