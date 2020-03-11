#!/bin/bash
set -eo pipefail
__dirname=$(cd $(dirname "$0"); pwd -P)
cd "${__dirname}"

source .config
cd ./ODM 

/usr/bin/docker system prune -f

env -i git pull origin master

/usr/bin/docker DOCKER_BUILDKIT=1 build --no-cache --squash -t opendronemap/odm:latest -f portable.Dockerfile .

/usr/bin/docker DOCKER_BUILDKIT=1 build --no-cache --squash -t opendronemap/odm:latest-avx -f Dockerfile .

echo $DOCKER_PASS | /usr/bin/docker login -u $DOCKER_USER --password-stdin

/usr/bin/docker push opendronemap/odm:latest
/usr/bin/docker push opendronemap/odm:latest-avx

# Tag
VERSION=$(cat VERSION)
VERSION_AVX=$VERSION"-avx"
/usr/bin/docker tag opendronemap/odm:latest "opendronemap/odm:$VERSION"
/usr/bin/docker push "opendronemap/odm:$VERSION"

/usr/bin/docker tag opendronemap/odm:latest "opendronemap/odm:$VERSION_AVX"
/usr/bin/docker push "opendronemap/odm:$VERSION_AVX"


if [ -e ./post.sh ]; then
	./post.sh
fi
