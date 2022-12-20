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
					groupManager;;
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
groupManager() {
	managerVal=1
	while [ "$managerVal" -eq "1" ]; do
		clear
		echo -e "\nGroup Manager Menu!"
		echo "***************"
		echo "1. Create group"
		echo "2. List User Groups"
		echo "3. List Users In Chosen Group"
		echo "4. Add User To Group"
		echo "5. Remove User From Group"
		echo "6. Remove A User Created Group"
		echo "7. Back To Main Menu"
		read -n 1 -p "Enter your option here: " -s USERCHOICE
		clear

		case $USERCHOICE in
			1)
				groupName=""
				read -p "Enter desired group name: " groupName
				groupadd $groupName
				if [ $? -eq 0 ]; then
					clear
					echo -e "\nGroup "$groupName" created!\nPress any button to continue"
					read -n 1
				else	
					clear
					echo -e "\nGroup "$groupName" already exists! No new group was created!"
					echo -e "\nPress any button to continue"
					read -n 1
				fi
				;;
			2)
				getent group | egrep ":[0-9][0-9][0-9][0-9]:" | cut -d ':' -f1 
				echo -e "\nPress any button to go back to main menu"
				read -n 1
				;;
			3)
				groupName=""
				read -p "Enter which groups members you wish to display: " groupName
				getent group $groupName
				if [ $? -eq 0 ]; then
					grep $groupName /etc/passwd
					if [ $? -eq 0 ]; then
						clear
						echo -e "\nGroup members of "$groupName": "
						echo -e -n ""$groupName""
						getent group $groupName | cut -d ':' -f4
						echo -e "\nPress any button to continue"
						read -n 1
					else	
						clear
						echo -e "\nGroup members of "$groupName": "
						getent group $groupName | cut -d ':' -f4
						echo -e "\nPress any button to continue"
						read -n 1
					fi
				else	
					clear
					echo -e "\nThere is no group with that name"
					echo -e "\nPress any button to continue"
					read -n 1
				fi
				;;
			4)
				groupName=""
				userName=""
				read -p "Enter the name of the user you wish to add to a group : " userName
				grep $userName /etc/passwd
				if [ $? -eq 0 ]; then
					clear
					read -p "Enter which group you want the member to join: " groupName
					getent group $groupName
					if [ $? -eq 0 ]; then
						usermod -a -G $groupName $userName
						clear
						echo -e "\n"$userName" has now been added to "$groupName""
						echo -e "\nPress any button to continue"
						read -n 1
					else
						clear
						echo -e "\nChosen group does not exist!"
						echo -e "\nPress any button to continue"
						read -n 1
					fi
				else
					clear
						echo -e "\nChosen user does not exist!"
						echo -e "\nPress any button to continue"
						read -n 1
				fi
				;;
			5)
				groupName=""
				userName=""
				read -p "Enter the name of the user you wish to remove from a group : " userName
				grep $userName /etc/passwd
				if [ $? -eq 0 ]; then
					clear
					read -p "Enter which group you want the member removed from: " groupName
					getent group $groupName
					if [ $? -eq 0 ]; then
						gpasswd --delete $userName $groupName
						clear
						echo -e "\n"$userName" has now been removed from "$groupName""
						echo -e "\nPress any button to continue"
						read -n 1
					else
						clear
						echo -e "\nChosen group does not exist!"
						echo -e "\nPress any button to continue"
						read -n 1
					fi
				else
					clear
						echo -e "\nChosen user does not exist!"
						echo -e "\nPress any button to continue"
						read -n 1
				fi

				;;
			6)
				groupName=""
				read -p "Enter the name of the group you wish to delete: " groupName
				groupdel $groupName
				if [ $? -eq 0 ]; then
					clear
					echo -e "\nGroup "$groupName" deleted!\nPress any button to continue"
					read -n 1
				else	
					clear
					echo -e "\nGroup "$groupName" doesnt exist! No group was deleted!"
					echo -e "\nPress any button to continue"
					read -n 1
				fi
				;;
			7)
				managerVal=0;;
			*)
				echo "Invalid input";;
		esac
	done
}

networkInfo() {
	echo -e "\nComputer: \c"
	hostname
	echo -e "Network Interfaces:"
	ip link | awk -F: '{print $2}' | sed 's/00$//' | grep -e [0-9] -e [a-z] -e [A-Z] | awk '{$1=$1}1' | tail -n +2
	echo -e "Showing network info"
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
