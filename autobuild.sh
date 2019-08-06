#!/bin/bash
set -eo pipefail
__dirname=$(cd $(dirname "$0"); pwd -P)
cd "${__dirname}"

source .config
cd ./ODM 

/usr/bin/docker system prune -f

git pull origin master

/usr/bin/docker build --no-cache --squash -t opendronemap/odm:latest -f portable.Dockerfile .

echo $DOCKER_PASS | /usr/local/bin/docker login -u $DOCKER_USER --password-stdin

/usr/bin/docker push opendronemap/odm:latest
