#!/bin/bash
set -e
cd "$(dirname "$0")"
docker build --pull -t oggm-bokeh-runner runner
docker rm --force oggm-bokeh-runner || true
docker run -d -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped --name oggm-bokeh-runner oggm-bokeh-runner
