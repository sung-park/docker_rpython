#!/usr/bin/env bash

# delete password
unset USER_PASS

# start supervisord
service supervisor start 

# start ssh
service ssh start

# user login
sudo -u $USER_ID -i '/bin/bash'

