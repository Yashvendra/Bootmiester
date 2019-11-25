#!/bin/bash 

clear
printf '\033]2; INSTALLER\a'
echo -e "Press \e[1;33many key\e[0m to install the script..."
read -n 1 
clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$DIR" != "/root/bootmiester" ]]
then
	echo -e "You didn't follow the instructions, I will try to install it for you..."
	sleep 4
	if [[ -d /root/bootmiester ]]
	then 
		rm -r /root/bootmiester
	fi
	mkdir /root/bootmiester
	cp -r "$DIR"/* /root/bootmiester
	chmod +x /root/bootmiester/install.sh
	#gnome-terminal -- bash -c "sudo /root/bootmiester/install.sh; exec bash"
fi
echo -e "Installing Bootmiester..."
sleep 1
echo -e "Fixing permissions..."
sleep 2
chmod +x /root/bootmiester/bootmiester.sh
clear
echo -e "Copying script to /bin/bootmiester"
cd /root/bootmiester
cp /root/bootmiester/bootmiester.sh /bin/bootmiester
clear

while true
do  
	clear
	echo -e "Are you \e[1;33mu\e[0mpdating or \e[1;33mi\e[0mnstalling the script?(\e[1;33mu\e[0m/\e[1;33mi\e[0m): "
	echo -e "Only use 'i' for the first time."
	read UORI
	if [[ "$UORI" = "u" ]]
	then 
		clear 
		echo -e "Type 'changelog' to see what's new on this version"
		sleep 3
		break
	elif [[ "$UORI" = "i" ]]
	then 
		clear
		BASHCHECK=$(cat ~/.bashrc | grep "/bin/bootmiester")
		if [[ "$BASHCHECK" != "" ]]
		then 
			echo -e "I SAID USE i ONLY ONE TIME..........."
			sleep 3
			break
		fi
		echo -e "Adding Bootmiester to PATH so you can access it from anywhere"
		sleep 1
		export PATH=/bin/bootmiester:$PATH
		sleep 1
		echo "export PATH=/bin/bootmiester:$PATH" >> ~/.bashrc
		sleep 1
		clear
		break
	fi
done
clear 
echo -e "DONE"
sleep 1
clear
echo -e "Installation is finished. Type 'sudo bootmiester' to launch the script after we exit."
sleep 2
exit

