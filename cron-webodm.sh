#!/bin/bash
set -eo pipefail
__dirname=$(cd $(dirname "$0"); pwd -P)
cd "${__dirname}"

cd WebODM
git pull odm master
git push origin master

