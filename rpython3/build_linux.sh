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

if read -sp "user password: " USER_PASS; then
  echo
  if [ -z "$USER_PASS" ]; then
    USER_PASS=$DEFAULT_USER_PASS
  fi
  if read -sp "password (again): " USER_PASS2; then
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

eval $COMMAND

unset USER_PASS
unset USER_PASS2

