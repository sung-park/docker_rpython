#!/usr/bin/env bash

# delete password
unset USER_PASS
unset USER_PASS2

# start and stop services
service ssh start

# postgres setup
service postgresql start
sudo -u postgres psql postgres -q -c "CREATE ROLE admin WITH LOGIN SUPERUSER PASSWORD 'adminpass'"
sudo -u postgres psql postgres -q -f "/home/$USER_ID/.postgres_db_setup.sql"
service postgresql stop

# start supervisord
sudo -u $USER_ID -i '/usr/bin/supervisord'

# user login
sudo -u $USER_ID -i '/bin/bash'
