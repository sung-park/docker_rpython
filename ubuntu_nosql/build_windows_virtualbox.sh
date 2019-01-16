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

# for windows =====================================================

dos2unix.exe ./.bash_profile ./.docker-entrypoint.sh ./.postgres_db_setup.sql ./6379-docker.conf ./supervisord.conf

DOCKER_MACHINE="/c/Program Files/Docker Toolbox/docker-machine.exe"

if [ ! -z "$VBOX_MSI_INSTALL_PATH" ]; then
  VBOXMANAGE="${VBOX_MSI_INSTALL_PATH}VBoxManage.exe"
else
  VBOXMANAGE="${VBOX_INSTALL_PATH}VBoxManage.exe"
fi

if [ ! -f "${DOCKER_MACHINE}" ] || [ ! -f "${VBOXMANAGE}" ]; then
  echo "Either VirtualBox or Docker Machine are not installed. Please re-run the Toolbox Installer and try again."
  exit 1
fi

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

docker () {
  MSYS_NO_PATHCONV=1 docker.exe $@
}
export -f docker

eval ${COMMAND}

exec "${BASH}" --login -i
