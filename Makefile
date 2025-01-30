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

# Remove the volumes
clean:
	docker volume rm DataBase WordPress

# Run docker compose in the background and rebuild images and containers.
recreate:
	docker compose -f ./srcs/docker-compose.yml up -d --build --force-recreate

.PHONY: stop clean re all
