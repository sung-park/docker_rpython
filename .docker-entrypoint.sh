
# delete password
unset USER_PASS

# start supervisord
/home/$USER_ID/anaconda2/bin/supervisord -c /etc/supervisord.conf

# enable ipyparallel
cd /home/$USER_ID/.jupyter 
sudo -u $USER_ID /home/$USER_ID/anaconda2/bin/ipcluster nbextension enable

# user login
sudo -u $USER_ID -i '/bin/bash'

