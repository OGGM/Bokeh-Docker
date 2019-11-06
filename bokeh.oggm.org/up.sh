#!/bin/bash

docker-compose() {
	docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v "$PWD:$PWD" \
		-w="$PWD" \
		-e WS_ORIGIN \
		docker/compose:1.24.1 "$@"
}

cd "$(dirname "$0")"
docker-compose down
docker-compose build --pull
docker-compose up "$@"
