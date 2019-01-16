#!/bin/bash

trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong... Press any key to continue..."' EXIT

VM=default
VM_SIZE=100000
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

COMMAND="docker build $BUILD_CACHE --rm=true -t $IMAGE_NAME:$TAG . 2>&1 | tee $(date +"%Y%m%d-%H%M%S").log"

# for mac =========================================================

DOCKER_MACHINE="docker-machine"
VBOXMANAGE="VBoxManage"

"${VBOXMANAGE}" list vms | grep \""${VM}"\" &> /dev/null
VM_EXISTS_CODE=$?

set -e

if [ ${VM_EXISTS_CODE} -eq 1 ]; then
  "${DOCKER_MACHINE}" rm -f "${VM}" &> /dev/null || :
  rm -rf ~/.docker/machine/machines/"${VM}"
  "${DOCKER_MACHINE}" create -d virtualbox --virtualbox-disk-size "40000" "${VM}"
fi

echo $("${DOCKER_MACHINE}" status ${VM} 2>&1)
VM_STATUS="$("${DOCKER_MACHINE}" status ${VM} 2>&1)"
if [ "${VM_STATUS}" != "Running" ]; then
  "${DOCKER_MACHINE}" start "${VM}"
  yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
fi

eval "$("${DOCKER_MACHINE}" env --shell=bash ${VM})"

eval ${COMMAND}
