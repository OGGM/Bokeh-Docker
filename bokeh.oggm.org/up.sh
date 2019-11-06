#!/bin/bash
cd "$(dirname "$0")"
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:$PWD" \
    -w="$PWD" \
    -e WS_ORIGIN \
    docker/compose:1.24.1 up "$@"
