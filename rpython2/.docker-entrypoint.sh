#!/usr/bin/env bash

# delete password
unset USER_PASS

# start syslog
service rsyslog start

# start ssh
service ssh start

# start supervisord
sudo -u $USER_ID -i '/usr/bin/supervisord'

# user login
sudo -u $USER_ID -i '/bin/bash'

