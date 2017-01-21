#!/usr/bin/env bash

# delete password
unset USER_PASS

# start supervisord
/usr/bin/supervisord -c /etc/supervisord.conf

# start ssh
/usr/sbin/sshd

# user login
sudo -u $USER_ID -i '/bin/bash'

