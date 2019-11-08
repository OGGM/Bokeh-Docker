#!/bin/bash
set -xe

rm -rf repo
git clone https://github.com/OGGM/Bokeh-Docker.git repo
cd repo/bokeh.oggm.org

docker-compose down --remove-orphans
docker system prune -f
docker-compose build --pull
docker-compose up -d

while true; do
	sleep 300
	git fetch || continue
	if [ $(git rev-parse @) != $(git rev-parse FETCH_HEAD) ]; then
		git reset --hard FETCH_HEAD
		git clean -fxd

		docker-compose down --remove-orphans
		docker system prune -f
		docker-compose build --pull
		docker-compose up -d
	fi
done
