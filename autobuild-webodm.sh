#!/bin/bash
set -eo pipefail
__dirname=$(cd $(dirname "$0"); pwd -P)
cd "${__dirname}"

source .config
cd ./WebODM

/usr/bin/docker system prune -f

env -i git pull origin master

/usr/bin/docker build --no-cache --squash -t opendronemap/webodm_webapp:latest .

echo $DOCKER_PASS | /usr/bin/docker login -u $DOCKER_USER --password-stdin

/usr/bin/docker push opendronemap/webodm_webapp:latest

VERSION=$(cat package.json | jq -r '.version')
/usr/bin/docker tag opendronemap/webodm_webapp:latest opendronemap/webodm_webapp:$VERSION
/usr/bin/docker push opendronemap/webodm_webapp:$VERSION

