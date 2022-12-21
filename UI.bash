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
					userMenu;;
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

userMenu() {
	USERMENUCHOICE=1
	while [ "$USERMENUCHOICE" -eq "1" ]; do
		clear
		echo -e "\nUserMenu"
		echo "************************************"
		echo -e "1. Add user"
		echo -e "2. Delete user"
		echo -e "3. List all users"
		echo -e "4. View all attributes for a user"
		echo -e "5. Change user attributes"
		echo -e "6. Return"
		read -n 1 -p "Enter your option here: " -s USERCHOICE
		clear

		case $USERCHOICE in
				1)
					USERNAME=""
					echo "************************************"
					echo "Follow the steps below to add a user"
					echo "************************************"
					read -p "Enter username (MAX 32): " USERNAME
					id $USERNAME &> /dev/null
					if [ $? = 0 ]; then
						echo "This user already exists!"
					else
						adduser $USERNAME
						echo "The user $USERNAME has been added!"
					fi
					echo -e "\nPress any button to continue"
					read -n 1
					;;
				2)
					USERNAME=""
					echo "************************************"
					echo "Follow these steps to delete a user"
					echo "************************************"
					read -p "Enter the user: " USERNAME
					id $USERNAME &> /dev/null
					if [ $? = 1 ]; then
						echo "This user does not exist!"
					else					
						userdel $USERNAME
						echo "This user $USERNAME has been deleted!"
					fi
					echo -e "\nPress any button to continue"
					read -n 1
					;;
				3)
					echo "**************************************"
					echo "Displaying all the users on the system"
					echo "**************************************"
					grep [0-9] /etc/passwd | grep -v -e nologin | awk -F: '{print $3, $1}' | column -t -N "USERID,USERNAME" | awk 'NR == 1; NR > 1 {print $0 | "sort -n"}'
					echo -e "\nPress any button to continue"
					read -n 1
					;;
				4)
					USERNAME=""
					echo "************************************"					
					echo "Show attributes for specific user"
					echo "************************************"
					read -p "Enter username to view attributes: " USERNAME
					id $USERNAME &> /dev/null
					if [ $? = 1 ]; then
						echo "This user does not exist!"
					else
						echo "Attributes for user: $USERNAME"
						echo -e "User:\t\t$USERNAME"
						echo -e "User ID:\t\c"
						id $USERNAME | awk '{print $1}' | sed 's/[^0-9]*//g'
						echo -e "Group ID: \t\c"
						id $USERNAME | awk '{print $2}' | sed 's/[^0-9]*//g'
						echo -e "Comment:\t\c"
						getent passwd $USERNAME | sed 's/,/ /g' | awk -F: '{print $5}'
						echo -e "Directory:\t\c"
						getent passwd $USERNAME | sed 's/,/ /g' | awk -F: '{print $6}'
						echo -e "Shell\t\t\c"
						getent passwd $USERNAME | sed 's/,/ /g' | awk -F: '{print $7}'
					fi	
					echo -e "\nPress any button to continue"
					read -n 1	
					;;
				5)
					ATTRIBUTES_FLAG=1
					
					while [ "$ATTRIBUTES_FLAG" -eq "1" ]; do
						clear
						echo "************************************"
						echo "Change user attributes"
						echo "************************************"
						echo -e "\n1. Change username"
						echo "2. Change userID"
						echo "3. Change home directory"
						echo "4. Change shell path"
						echo "5. Change user comment"
						echo "6. Change user password"
						echo "7. Return"
						read -n 1 -p "Enter your option here: " USERCHOICE
						clear

						case $USERCHOICE in
							1)
						
								USERNAME=""
								echo "************************************"					
								echo "Change username"
								echo "************************************"								
								read -p "Enter old username: " USERNAME
								id $USERNAME &> /dev/null
								if [ $? = 1 ]; then
									echo "This user does not exist!"									
								else
									NEWUSERNAME=""
									read -p "Enter new username: " NEWUSERNAME
									usermod -l $NEWUSERNAME $USERNAME
								fi
								;;
							2)
								NEWID=0
								USERNAME=""
								echo "************************************"					
								echo "Change userID"
								echo "************************************"								

								read -p "Enter user: " USERNAME
								id $USERNAME &> /dev/null
								if [ $? = 1 ]; then
									echo "This user does not exist!"
								else	
									NEWUSERNAME=""
									read -p "Enter new userID (MUST BE UNIQUE): " NEWID
									usermod -u $NEWID $USERNAME
								fi
								;;
							3)
								USERNAME=""
								NEWHOME=""
								echo "************************************"					
								echo "Change home directory"
								echo "************************************"	
								read -p "Enter user: " USERNAME
								id $USERNAME &> /dev/null
								if [ $? = 1 ]; then
									echo "This user does not exist!"
								else
									read -p "Enter the new home directory: " NEWHOME
									usermod -d $NEWHOME $USERNAME
								fi
								;;
							4)
								USERNAME=""
								NEWSHELL=""
								echo "************************************"					
								echo "Change shell path"
								echo "************************************"								

								read -p "Enter username: " USERNAME
								id $USERNAME &> /dev/null
								if [ $? = 1 ]; then
									echo "This user does not exist!"
								else
									read -p "Enter new shell path: " NEWSHELL
									usermod -s $NEWSHELL $USERNAME
								fi
								;;
							5)
								USERNAME=""
								NEWCOMMENT=""
								echo "************************************"					
								echo "Change user comment"
								echo "************************************"								

								read -p "Enter username: " USERNAME
								id $USERNAME &> /dev/null
								if [ $? = 1 ]; then
									echo "This user does not exist!"
								else
									read -p "Enter new comment: " NEWCOMMENT
									usermod -c "$NEWCOMMENT" $USERNAME
								fi
								;;
							6)
								USERNAME=""
								echo "************************************"					
								echo "Change user password"
								echo "************************************"								
								read -p "Enter username: " USERNAME
								id $USERNAME &> /dev/null
								if [ $? = 1 ]; then
									echo "This user does not exist!"
								else
									NEWPASSWORD=""
									read -p "Enter new password: " NEWPASSWORD
									usermod -p $NEWPASSWORD $USERNAME
								fi
								;;
							7)
								ATTRIBUTES_FLAG=0
								return
								;;
							*)
								echo "Invalid input";;
							esac
						echo -e "\nPress any button to continue"
						read -n 1
					done					
					;;
				6)
					echo "************************************"
					echo "Returning to the main menu!"
					echo "************************************"
					sleep 2
					return
					;;
				*)
					echo "Invalid input";;
			esac
		done

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
	ip link show | awk -F: '{print $2}' | sed 's/00$//' | grep -e [0-9] -e [a-z] -e [A-Z] | awk '{$1=$1}1'
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

mappFunction(){			
	while [ "$EXITVAR" -eq "1" ]; do
		clear
		echo "************************************"
		echo "Change user attributes"
		echo "************************************"
		echo -e "\n1. Change username"
		echo "2. Change userID"
		echo "3. Change home directory"
		echo "4. Change shell path"
		echo "5. Change user comment"
		echo "6. Change user password"
		echo "7. Return"
		read -n 1 -p "Enter your option here: " USERCHOICE
		clear

		case $USERCHOICE in
			1)

				
				;;
			2)
				
				;;
			3)
				
				;;
			4)
				
				;;
			5)
				
				;;
			6)
				
				;;
			7)
				ATTRIBUTES_FLAG=0
				return
				;;
			*)
				echo "Invalid input";;
}

UI
