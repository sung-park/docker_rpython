
# delete password
unset USER_PASS

# start supervisord
/home/$USER_ID/anaconda2/bin/supervisord -c /etc/supervisord.conf

# user login
sudo -u $USER_ID -i '/bin/bash'

