#!/usr/bin/env bash

SERVER_INSTANCES=4

# Install Docker
curl -sSL https://get.docker.com/ | sh
usermod -aG docker vagrant

# Run third-party Docker containers.
docker run --name my-redis -d redis

# Build custom web server container.
docker build -t mminer/server /vagrant/app

# Run instances of server container.
for i in $(seq 1 $SERVER_INSTANCES); do
	# Create link with Redis server.
	docker run --name my-server-$i --link my-redis:redis -d mminer/server
done

# Build and run custom Nginx container with links to server instances.
LINKS=$(for i in $(seq 1 $SERVER_INSTANCES); do echo -n " --link my-server-$i:SERVER$i"; done)
docker build -t mminer/nginx /vagrant/nginx
docker run --name my-nginx $LINKS -p 80:80 -d mminer/nginx
