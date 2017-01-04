#!/bin/bash

trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong... Press any key to continue..."' EXIT

DEFAULT_USER_ID="dockeruser"
DEFAULT_USER_PASS="dockeruserpass"
DEFAULT_USER_UID=1999
DEFAULT_USER_UID2=$(id -u $(whoami))
DEFAULT_USER_GID=$DEFAULT_USER_UID
DEFAULT_USER_GID2=$(id -g $(whoami))
DEFAULT_HTTPS_COMMENT="#"
IMAGE_NAME="datascienceschool/rpython3"

read -p "tag (default \"latest\"): " TAG
if [ -z "$TAG" ]; then
  TAG=latest
fi

read -p "user name (default \"dockeruser\"): " USER_ID
if [ -z "$USER_ID" ]; then
  USER_ID=$DEFAULT_USER_ID
fi

read -p "user uid (default $DEFAULT_USER_UID or current uid $DEFAULT_USER_UID2): " USER_UID
if [ -z "$USER_UID" ]; then
  USER_UID=$DEFAULT_USER_UID
fi

read -p "user gid (default $DEFAULT_USER_GID or current uid $DEFAULT_USER_GID2): " USER_GID
if [ -z "$USER_GID" ]; then
  USER_GID=$DEFAULT_USER_GID
fi

if read -t 5 -sp "user password: " USER_PASS; then
  echo
  if [ -z "$USER_PASS" ]; then
    USER_PASS=$DEFAULT_USER_PASS
  fi
  if read -t 5 -sp "password (again): " USER_PASS2; then
    if [ -z "$USER_PASS2" ]; then
      USER_PASS2=$DEFAULT_USER_PASS
    fi
    if [[ $USER_PASS != $USER_PASS2 ]]; then
      echo
      echo "passwords are different" >&2
      exit 1
    fi
    echo
  else
    echo -e "\nInput timed out" >&2
  exit 1
  fi
else
  echo -e "\nInput timed out" >&2
  exit 1
fi

read -p "https (y/n) (default n): " HTTPS_COMMENT
if [ -z "$HTTPS_COMMENT" ]; then
  HTTPS_COMMENT=$DEFAULT_HTTPS_COMMENT
else
  if [[ $HTTPS_COMMENT == 'y' ]]; then
    HTTPS_COMMENT=""
    echo "HTTPS_COMMENT unset"
  else
    HTTPS_COMMENT=$DEFAULT_HTTPS_COMMENT
    echo "HTTPS_COMMENT set to $DEFAULT_HTTPS_COMMENT"
  fi
fi

COMMAND="sudo docker build --rm=true -t $IMAGE_NAME:$TAG --build-arg USER_ID=$USER_ID --build-arg USER_PASS=$USER_PASS --build-arg USER_UID=$USER_UID --build-arg USER_GID=$USER_GID --build-arg HTTPS_COMMENT=$HTTPS_COMMENT . 2>&1 | tee $(date +"%Y%m%d-%H%M%S").log"

# for windows =====================================================

VM=default
VM_SIZE=100000
DOCKER_MACHINE="/c/Program Files/Docker Toolbox/docker-machine.exe"

if [ ! -z "$VBOX_MSI_INSTALL_PATH" ]; then
  VBOXMANAGE="${VBOX_MSI_INSTALL_PATH}VBoxManage.exe"
else
  VBOXMANAGE="${VBOX_INSTALL_PATH}VBoxManage.exe"
fi

BLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ ! -f "${DOCKER_MACHINE}" ] || [ ! -f "${VBOXMANAGE}" ]; then
  echo "Either VirtualBox or Docker Machine are not installed. Please re-run the Toolbox Installer and try again."
  exit 1
fi

"${VBOXMANAGE}" list vms | grep \""${VM}"\" &> /dev/null
VM_EXISTS_CODE=$?

set -e

if [ $VM_EXISTS_CODE -eq 1 ]; then
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

eval $COMMAND

unset USER_PASS
unset USER_PASS2

exec "${BASH}" --login -i

