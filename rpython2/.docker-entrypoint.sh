#!/usr/bin/env bash

# delete password
unset USER_PASS

# disable conda extension
jupyter nbextension disable nb_conda --py --sys-prefix
jupyter serverextension disable nb_conda --py --sys-prefix

# start supervisord
/home/$USER_ID/anaconda2/bin/supervisord -c /etc/supervisord.conf

# start ssh
/usr/sbin/sshd

# user login
sudo -u $USER_ID -i '/bin/bash'

