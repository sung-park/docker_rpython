#!/bin/bash

trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong... Press any key to continue..."' EXIT

IMAGE_NAME="datascienceschool/ubuntu"

DEFAULT_HTTPS_COMMENT="#"

read -p "tag (default \"latest\"): " TAG
if [ -z "$TAG" ]; then
  TAG=latest
fi

read -p "https (y/n) (default n): " HTTPS_COMMENT
if [ -z "$HTTPS_COMMENT" ]; then
  HTTPS_COMMENT=${DEFAULT_HTTPS_COMMENT}
else
  if [[ ${HTTPS_COMMENT} == 'y' ]]; then
    HTTPS_COMMENT=""
    echo "HTTPS_COMMENT unset"
  else
    HTTPS_COMMENT=${DEFAULT_HTTPS_COMMENT}
    echo "HTTPS_COMMENT set to $DEFAULT_HTTPS_COMMENT"
  fi
fi

read -p "build using cache (default \"y\"): " BUILD_CACHE
if [[ ${BUILD_CACHE} == 'n' ]]; then
    BUILD_CACHE="--no-cache"
else
    BUILD_CACHE=""
fi
echo $BUILD_CACHE

COMMAND="sudo docker build $BUILD_CACHE --rm=true -t $IMAGE_NAME:$TAG --build-arg HTTPS_COMMENT=$HTTPS_COMMENT . 2>&1 | tee $(date +"%Y%m%d-%H%M%S").log"

eval ${COMMAND}
