
IMAGES := $(shell docker images -f "dangling=true" -q)
CONTAINERS := $(shell docker ps -a -q -f status=exited)
VOLUME := glampipe-data
DB := c_access

clean:
	docker rm -f $(CONTAINERS)
	docker rmi -f $(IMAGES)

create_volume:
	docker volume create $(VOLUME)

build:
	docker build -t artturimatias/collectiveaccess:1.7.6 .
	
start:
	docker run --name collectiveaccess \
	--link mariadb:mysql \
	-p 80:80 \
	-v $(VOLUME):/var/www/providence/media \
	-e DB_USER=root \
	-e DB_PW=root \
	-e DB_NAME=$(DB) \
	artturimatias/collectiveaccess:1.7.6
