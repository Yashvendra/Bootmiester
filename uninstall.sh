#!/bin/bash

echo -e "Do you really want to uninstall the Bootmiester script from your system?(y/n)(Enter=no): "
read CHUN
if [ "$CHUN" = "y" ]
then 
	echo -e "If you have problems please contact me first."
	echo -e "Do you still wanna get rid of me?(y/n)(Enter=no): "
	read CHCHUN
	if [ "$CHCHUN" = "y" ]
	then 
		echo -e "Ok, uninstalling everything that has to with Bootmiester on your system"
		sleep 4
		rm -rf /bin/bootmiester
		echo -e "Done."
		sleep 1
		echo -e "You need to manually delete the bootmiester folder from your /root/ directory though..."
		sleep 2
		echo -e "Press any key to exit..."
		read
		exit
	else
		nouninstall
	fi
else
	nouninstall
fi	

function nouninstall
{
	echo -e "If you want any feature to be added, contact me @ yashkashyap00720@gmail.com"
	sleep 2
	echo -e " "
        echo -e "Yashvendra"
	sleep 1
	exit	
}
