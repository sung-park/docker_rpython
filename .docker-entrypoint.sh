
# delete password
unset USER_PASS

if [ -z "$1" ]
  then
	# start supervisord
	/home/$USER_ID/anaconda2/bin/supervisord --user=$USER_ID
  	# user login
    /bin/bash 
elif [ $1 == "service" ]
  then
	# start supervisord
	/home/$USER_ID/anaconda2/bin/supervisord --user=$USER_ID --nodaemon
fi
