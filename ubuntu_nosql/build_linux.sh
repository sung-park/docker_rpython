#!/bin/bash

trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong... Press any key to continue..."' EXIT

IMAGE_NAME="datascienceschool/ubuntu_nosql"

read -p "tag (default \"latest\"): " TAG
if [ -z "$TAG" ]; then
  TAG=latest
fi

read -p "build using cache (default \"y\"): " BUILD_CACHE
if [[ ${BUILD_CACHE} == 'n' ]]; then
    BUILD_CACHE="--no-cache"
else
    BUILD_CACHE=""
fi
echo $BUILD_CACHE

COMMAND="sudo docker build $BUILD_CACHE --rm=true -t $IMAGE_NAME:$TAG . 2>&1 | tee $(date +"%Y%m%d-%H%M%S").log"

eval ${COMMAND}
