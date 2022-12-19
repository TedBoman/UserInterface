#!/bin/bash
EXITVAR=1
USERCHOICE=0

UI() {
	if [ "$(whoami)" != root ]; then #checks if user is root
		echo "Please run this program as root."
		exit 1

	else
		while [ "$EXITVAR" -eq "1" ]; do
			clear
			echo -e "\nSuperUser Menu!"
			echo "***************"
			echo "1. Network info"
			echo "2. Users"
			echo "3. Groups"
			echo "4. Directories"
			echo "5. Exit"
			read -n 1 -p "Enter your option here: " -s USERCHOICE
			clear

			case $USERCHOICE in
				1)
					networkInfo;;
				2)
					echo "test2";;
				3)
					echo "test3";;
				4)
					echo "test4";;
				5)
					EXITVAR=0
					echo "Thank you come again!";;
				*)
					echo "Invalid input";;
			esac
		done
	fi
}

networkInfo() {
	echo -e "\nShowing network info"
					echo -e "IP Address: \c"
					hostname -i
					echo -e "MAC Address: \c"
					ip addr | awk '/ether/ {print $2}'
					echo -e "Gateway: \c"
					ip r | grep default | cut -d " " -f3
					echo -e "Status: \c"
					ip link show | grep enp | cut -d " " -f9
					echo -e "\nPress any button to continue"
					read -n 1
}



UI
