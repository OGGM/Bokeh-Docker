#!/bin/bash
set -xe

rm -rf repo
git clone --branch fix-build-pathing https://github.com/gampnico/Bokeh-Docker.git repo
cd repo/bokeh.oggm.org

docker compose down --remove-orphans
docker compose pull
docker compose build --pull
docker compose up -d
docker system prune -a -f

while true; do
	sleep 300
	git fetch || continue
	OHEAD=$(git rev-parse @)
	if [ ${OHEAD} != $(git rev-parse FETCH_HEAD) ]; then
		git reset --hard FETCH_HEAD &&
		git clean -fxd &&

		docker compose down --remove-orphans &&
		docker compose pull &&
		docker compose build --pull &&
		docker compose up -d &&
		docker system prune -a -f ||

		git reset --hard ${OHEAD}
	fi
done
