#Linux Case Assignment
#Ted Boman
#Theo Gould
#Grupp 35


#!/bin/bash
EXITVAR=1
USERCHOICE=0

UI() {
	if [ "$(whoami)" != root ]; then #checks if user is root
		echo -e "\033[1;31mPlease run this program as root.\033[0m"
		exit 1

	else
		while [ "$EXITVAR" -eq "1" ]; do
			clear
			echo "************************************"
			echo -e "\033[1mSuperUser Menu!\033[0m"
			echo "************************************"
			echo -e "\033[1m1. Network info\033[0m"
			echo -e "\033[1m2. Users\033[0m"
			echo -e "\033[1m3. Groups\033[0m"
			echo -e "\033[1m4. Directories\033[0m"
			echo -e "\033[1m5. Exit\033[0m"
			read -e -n 1 -p "Enter your option here: " -s USERCHOICE
			clear

			case $USERCHOICE in
				1)
					networkInfo;;
				2)
					userMenu;;
				3)
					groupManager;;
				4)
					folderFunction;;
				5)
					EXITVAR=0
					echo -e "\033[1mThank you come again!\033[0m";;
				*)
					echo -e "\033[1mInvalid input\033[0m";;
			esac
		done
	fi
}


networkInfo() {
	echo "************************************"
	echo -e "\033[1mNetwork information\033[0m"
	echo "************************************"
	echo -e "\n\033[1mComputer: \c\033[0m"
	hostname
	echo -e "\033[1mNetwork Interfaces: \n\c\033[0m"
	ip link show | awk -F: '{print $2}' | sed 's/00$//' | grep -e [0-9] -e [a-z] -e [A-Z] | awk '{$1=$1}1' | sed '1d'
	echo -e "\033[1mShowing network info: \033[0m"
	echo -e "\033[1mIP Address: \c\033[0m"
	hostname -i
	echo -e "\033[1mMAC Address: \c\033[0m"
	ip addr | awk '/ether/ {print $2}'
	echo -e "\033[1mGateway: \c\033[0m"
	ip r | grep default | cut -d " " -f3
	echo -e "\033[1mStatus: \c\033[0m"
	ip link show | grep enp | cut -d " " -f9
	echo -e "\nPress any button to continue"
	read -e -n 1
}


userMenu() {
	USERMENUCHOICE=1
	while [ "$USERMENUCHOICE" -eq "1" ]; do
		clear
		echo "************************************"
		echo -e "\033[1mUserMenu\033[0m"
		echo "************************************"
		echo -e "\033[1m1. Add user\033[0m"
		echo -e "\033[1m2. Delete user\033[0m"
		echo -e "\033[1m3. List all users\033[0m"
		echo -e "\033[1m4. View all attributes for a user\033[0m"
		echo -e "\033[1m5. Change user attributes\033[0m"
		echo -e "\033[1m6. Return\033[0m"
		read -e -n 1 -p "Enter your option here: " -s USERCHOICE
		clear

		case $USERCHOICE in
				1)
					USERNAME=""
					GECOS=""
					echo "************************************"
					echo -e "\033[1mFollow these steps to create a user\033[0m"
					echo "************************************"
					read -e -p "Enter username (MAX 32): " USERNAME
					if [ -n "$USERNAME" ]; then
						read -e -p "Enter your full name: " GECOS
						id $USERNAME &> /dev/null
						if [ $? = 0 ]; then
							echo "This user already exists!"
						else
							adduser --gecos "$GECOS" --force-badname $USERNAME
							echo "The user $USERNAME has been added!"
						fi
					else
						echo "Please enter a username to create a user"
					fi
					echo -e "\nPress any button to continue"
					read -e -n 1
					;;
				2)
					USERNAME=""
					echo "************************************"
					echo -e "\033[1mFollow these steps to delete a user\033[0m"
					echo "************************************"
					read -e -p "Enter the user: " USERNAME
					if [ -n "$USERNAME" ]; then
						id $USERNAME &> /dev/null
						if [ $? = 1 ]; then
							echo "This user does not exist!"
						else					
							userdel --remove $USERNAME &> /dev/null
							echo "This user $USERNAME has been deleted!"
						fi
					else
						echo "Please enter a username to delete"
					fi
					echo -e "\nPress any button to continue"
					read -e -n 1
					;;
				3)
					echo "**************************************"
					echo -e "\033[1mDisplaying all the users on the system\033[0m"
					echo "**************************************"
					grep [0-9] /etc/passwd | grep -v -e nologin | awk -F: '{print $3, $1}' | column -t -N "USERID,USERNAME" | awk 'NR == 1; NR > 1 {print $0 | "sort -n"}'
					echo -e "\nPress any button to continue"
					read -e -n 1
					;;
				4)
					USERNAME=""
					echo "************************************"					
					echo -e "\033[1mShow attributes fo a specific user\033[0m"
					echo "************************************"
					read -e -p "Enter username to view attributes: " USERNAME
					if [ -n "$USERNAME" ]; then
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
							echo -e "Groups for user \c"
							groups $USERNAME
						fi
					else
						echo "Please enter a username to view attributes"
					fi
					echo -e "\nPress any button to continue"
					read -e -n 1	
					;;
				5)
					ATTRIBUTES_FLAG=1
					
					while [ "$ATTRIBUTES_FLAG" -eq "1" ]; do
						clear
						echo "************************************"
						echo -e "\033[1mChange user attributes\033[0m"
						echo "************************************"
						echo -e "\n\033[1m1. Change username\033[0m"
						echo -e "\033[1m2. Change userID\033[0m"
						echo -e "\033[1m3. Change home directory\033[0m"
						echo -e "\033[1m4. Change shell path\033[0m"
						echo -e "\033[1m5. Change user comment\033[0m"
						echo -e "\033[1m6. Change user password\033[0m"
						echo -e "\033[1m7. Return\033[0m"
						read -e -n 1 -p "Enter your option here: " USERCHOICE
						clear

						case $USERCHOICE in
							1)
								USERNAME=""
								echo "************************************"					
								echo -e "\033[1mChange username\033[0m"
								echo "************************************"
								read -e -p "Enter old username: " USERNAME
								if [ -n "$USERNAME" ]; then
									id $USERNAME &> /dev/null
									if [ $? = 1 ]; then
										echo "This user does not exist!"									
									else
										NEWUSERNAME=""
										read -e -p "Enter new username: " NEWUSERNAME
										usermod -l $NEWUSERNAME $USERNAME
									fi
								else
									echo "Please enter a username to change attribute"
								fi
								echo -e "\nPress any button to continue"
								read -e -n 1
								;;
							2)
								NEWID=0
								USERNAME=""
								echo "************************************"					
								echo -e "\033[1mChange userID\033[0m"
								echo "************************************"								

								read -e -p "Enter user: " USERNAME
								if [ -n "$USERNAME" ]; then
									id $USERNAME &> /dev/null
									if [ $? = 1 ]; then
										echo "This user does not exist!"
									else	
										NEWUSERNAME=""
										read -e -p "Enter new userID (MUST BE UNIQUE): " NEWID
										usermod -u $NEWID $USERNAME
									fi
								else
									echo "Please enter a username to change attribute"
								fi
								echo -e "\nPress any button to continue"
								read -e -n 1
								;;
							3)
								USERNAME=""
								NEWHOME=""
								echo "************************************"					
								echo -e "\033[1mChange home directory\033[0m"
								echo "************************************"
								read -e -p "Enter user: " USERNAME
								if [ -n "$USERNAME" ]; then
									id $USERNAME &> /dev/null
									if [ $? = 1 ]; then
										echo "This user does not exist!"
									else
										read -e -p "Enter the new home directory: " NEWHOME
										usermod -d $NEWHOME $USERNAME
									fi
								else
									echo "Please enter a username to change attribute"
								fi
								echo -e "\nPress any button to continue"
								read -e -n 1
								;;
							4)
								USERNAME=""
								NEWSHELL=""
								echo "************************************"					
								echo -e "\033[1mChange shell path\033[0m"
								echo "************************************"								

								read -e -p "Enter username: " USERNAME
								if [ -n "$USERNAME" ]; then
									id $USERNAME &> /dev/null
									if [ $? = 1 ]; then
										echo "This user does not exist!"
									else
										read -e -p "Enter new shell path: " NEWSHELL
										usermod -s $NEWSHELL $USERNAME
									fi
								else
									echo "Please enter a username to change attribute"
								fi
								echo -e "\nPress any button to continue"
								read -e -n 1
								;;
							5)
								USERNAME=""
								NEWCOMMENT=""
								echo "************************************"					
								echo -e "\033[1mChange user comment\033[0m"
								echo "************************************"								

								read -e -p "Enter username: " USERNAME
								if [ -n "$USERNAME" ]; then
									id $USERNAME &> /dev/null
									if [ $? = 1 ]; then
										echo "This user does not exist!"
									else
										read -e -p "Enter new comment: " NEWCOMMENT
										usermod -c "$NEWCOMMENT" $USERNAME
									fi
								else
									echo "Please enter a username to change attribute"
								fi
								echo -e "\nPress any button to continue"
								read -e -n 1
								;;
							6)
								USERNAME=""
								echo "************************************"					
								echo -e "\033[1mChange user password\033[0m"
								echo "************************************"								
								read -e -p "Enter username: " USERNAME
								if [ -n "$USERNAME" ]; then
									id $USERNAME &> /dev/null
									if [ $? = 1 ]; then
										echo "This user does not exist!"
									else
										NEWPASSWORD=""
										read -e -p "Enter new password: " NEWPASSWORD
										usermod -p $NEWPASSWORD $USERNAME
									fi
								else
									echo "Please enter a username to change attribute"
								fi
								echo -e "\nPress any button to continue"
								read -e -n 1
								;;
							7)
								ATTRIBUTES_FLAG=0
								;;
							*)
								echo "Invalid input";;
							esac
						done					
					;;
				6)
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
		echo "************************************"
		echo -e "\033[1mGroup Manager Menu!\033[0m"
		echo "************************************"
		echo -e "\033[1m1. Create group\033[0m"
		echo -e "\033[1m2. List User Groups\033[0m"
		echo -e "\033[1m3. List Users In Chosen Group\033[0m"
		echo -e "\033[1m4. Add User To Group\033[0m"
		echo -e "\033[1m5. Remove User From Group\033[0m"
		echo -e "\033[1m6. Remove A User Created Group\033[0m"
		echo -e "\033[1m7. Back To Main Menu\033[0m"
		read -e -n 1 -p "Enter your option here: " -s USERCHOICE
		clear

		case $USERCHOICE in
			1)
				groupName=""
				echo "************************************"
				echo -e "\033[1mCreate a group\033[0m"
				echo "************************************"
				read -e -p "Enter desired group name: " groupName
				groupadd $groupName
				if [ $? -eq 0 ]; then
					clear
					echo "************************************"
					echo -e "\033[1mCreate a group\033[0m"
					echo "************************************"
					echo -e "\nGroup "$groupName" created!\nPress any button to continue"
					read -e -n 1
				else	
					clear
					echo "************************************"
					echo -e "\033[1mCreate a group\033[0m"
					echo "************************************"
					echo -e "\nGroup "$groupName" already exists! No new group was created!"
					echo -e "\nPress any button to continue"
					read -e -n 1
				fi
				;;
			2)
				echo "************************************"
				echo -e "\033[1mList User Groups\033[0m"
				echo "************************************"
				getent group | egrep ":[0-9][0-9][0-9][0-9]:" | cut -d ':' -f1 
				echo -e "\nPress any button to go back to main menu"
				read -e -n 1
				;;
			3)
				groupName=""
				echo "************************************"
				echo -e "\033[1mList Users In Chosen Group\033[0m"
				echo "************************************"
				groupName=""
				read -e -p "Enter which groups members you wish to display: " groupName
				getent group $groupName
				if [ $? -eq 0 ]; then
					if [ -z "$groupName" ]; then
						clear
						echo -e "\nNo group name was entered!"
						echo -e "\nPress any button to continue"
						read -e -n 1
					else 
						grep $groupName /etc/passwd
						if [ $? -eq 0 ]; then
							clear
							echo -e "\nGroup members of "$groupName": "
							echo -e -n ""$groupName""
							getent group $groupName | cut -d ':' -f4
							echo -e "\nPress any button to continue"
							read -e -n 1
							
						else	
							clear
							echo -e "\nGroup members of "$groupName": "
							getent group $groupName | cut -d ':' -f4
							echo -e "\nPress any button to continue"
							read -e -n 1
							
						fi
					fi
				else	
					clear
					echo -e "\nThere is no group with that name"
					echo -e "\nPress any button to continue"
					read -e -n 1
				fi
				;;
			4)
				groupName=""
				userName=""
				echo "************************************"
				echo -e "\033[1mAdd User To Group\033[0m"
				echo "************************************"
						read -e -p "Enter which group you want the member to join: " groupName
						if [ -n "$groupName" ]; then
							getent group $groupName
							if [ $? -eq 0 ]; then
								usermod -a -G $groupName $userName
								clear
								echo -e "\n"$userName" has now been added to "$groupName""
								echo -e "\nPress any button to continue"
								read -e -n 1
							else
								clear
								echo -e "\nChosen group does not exist!"
								echo -e "\nPress any button to continue"
								read -e -n 1
							fi
						else 
							clear			
							echo -e "\nNo group input detected"
							echo -e "\nPress any button to continue"
							read -e -n 1
						fi 
						echo -e "\n"$userName" has now been added to "$groupName""
						echo -e "\nPress any button to continue"
						read -e -n 1
				;;
			5)
				groupName=""
				userName=""
				echo "************************************"
				echo -e "\033[1mRemove User From Group\033[0m"
				echo "************************************"
				read -e -p "Enter the name of the user you wish to remove from a group : " userName
				if [ -n "$userName" ]; then
					grep $userName /etc/passwd
					if [ $? -eq 0 ]; then
						clear
						read -e -p "Enter which group you want the member removed from: " groupName
						if [ -n "$groupName" ]; then
							getent group $groupName
							if [ $? -eq 0 ]; then
								gpasswd --delete $userName $groupName
								clear
								echo -e "\n"$userName" has now been removed from "$groupName""
								echo -e "\nPress any button to continue"
								read -e -n 1
							else
								clear
								echo -e "\nChosen group does not exist!"
								echo -e "\nPress any button to continue"
								read -e -n 1
							fi
						else
							clear			
							echo -e "\nNo group input detected"
							echo -e "\nPress any button to continue"
							read -e -n 1
						fi
					else
						clear
						echo -e "\nChosen user does not exist!"
						echo -e "\nPress any button to continue"
						read -e -n 1
					fi
				else
					echo -e "\nNo user input detected!"
					echo -e "\nPress any button to continue"
					read -e -n 1
				fi
				;;
			6)
				groupName=""
				echo "************************************"
				echo -e "\033[1mDelete A Group\033[0m"
				echo "************************************"
				read -e -p "Enter the name of the group you wish to delete: " groupName
				groupdel $groupName
				if [ $? -eq 0 ]; then
					clear
					echo -e "\nGroup "$groupName" deleted!\nPress any button to continue"
					read -e -n 1
				else	
					clear
					echo -e "\nGroup "$groupName" doesnt exist! No group was deleted!"
					echo -e "\nPress any button to continue"
					read -e -n 1
				fi
				;;
			7)
				managerVal=0;;
			*)
				echo "Invalid input";;
		esac
	done
}

folderFunction(){
	FolderVar=1			
	while [ "$FolderVar" -eq "1" ]; do
		clear
		echo "************************************"
		echo -e "\033[1mDirectoryMenu\033[0m"
		echo "************************************"
		echo -e "\033[1m\n1. Create directory\033[0m"
		echo -e "\033[1m2. List contents of directory\033[0m"
		echo -e "\033[1m3. List and change attributes for a directory\033[0m"
		echo -e "\033[1m4. Delete a Directory\033[0m"
		echo -e "\033[1m5. Back to the main menu\033[0m"
		read -e -n 1 -p "Enter your option here: " USERCHOICE
		clear

		case $USERCHOICE in
			1)
				folderName=""
					echo "************************************"
					echo -e "\033[1mCreate directory\033[0m"
					echo "************************************"
				read -e -p "Enter desired folder name (Add path if you wish to create the folder somewhere else): " folderName
				if [ -n "$folderName" ]; then
					mkdir $folderName
					if [ $? -eq 0 ]; then
						clear
						echo -e "\nFolder $folderName was created!"
					else	
						clear
						echo -e "\nA folder with the name $folderName already exists!\nNo new folder was created!"
					fi
				else
					echo "Please enter the name of the new directory"
				fi
				echo -e "\nPress any button to continue"
				read -e -n 1
				;;
			2)
				desiredDirectory=""
					echo "************************************"
					echo -e "\033[1mList contents of directory\033[0m"
					echo "************************************"
				read -e -p "Enter desired directory to list its files and folders (leave empty for current working directory): " desiredDirectory
				if [ "$desiredDirectory" = "" ]; then
					desiredDirectory=$(pwd)
				fi
				if [ -d "$desiredDirectory" ]; then
					clear
					ls -1 $desiredDirectory
					echo -e "\nPress any button to continue"
					read -e -n 1
				else	
					clear
					echo -e "\nDesired folder doesnt exist!"
					echo -e "\nPress any button to continue"
					read -e -n 1
				fi
				;;
			3)
				DirVar=1
				while [ "$DirVar" -eq "1" ]; do
					clear
					echo "************************************"
					echo -e "\033[1mChange directory/folder attributes\033[0m"
					echo "************************************"
					echo -e "\033[1m\n1. Change owner for desired drectory or folder\033[0m"
					echo -e "\033[1m2. Change group for desired directory or folder\033[0m"
					echo -e "\033[1m3. Change permissions\033[0m"
					echo -e "\033[1m4. Apply sticky bit to a directory/folder\033[0m"
					echo -e "\033[1m5. Apply setgid on a directory/folder\033[0m"
					echo -e "\033[1m6. Show the last edited directory/folder\033[0m"
					echo -e "\033[1m7. Back to the main menu\033[0m"
					read -e -n 1 -p "Enter your option here: " USERCHOICE
					clear

					case $USERCHOICE in
						1)
							folderName=""
							newOwner=""
							echo "************************************"
							echo -e "\033[1mChange folder/directory owner\033[0m"
							echo "************************************"
							read -e -p "Enter the path and folder name to change its owner: " folderName
							if [ -d "$folderName" ]; then
								read -e -p "Enter the username of the folders new owner: " newOwner
								grep $newOwner /etc/passwd &> /dev/null
								if [ $? = 1 ]; then
									echo "This user does not exist!"
								else
									chown $newOwner $folderName
									if [ $? = 0 ]; then
										echo "Owner for $folderName has been changed to $newOwner"
									fi
								fi
							else
								echo "This folder/directory does not exist!"
							fi
							echo -e "\nPress any button to continue"
							read -e -n 1							
							;;
						2)
							folderName=""
							newGroup=""
							echo "************************************"
							echo -e "\033[1mChange folder/directory group owner\033[0m"
							echo "************************************"
							read -e -p "Enter the path and folder name to change its group owner: " folderName
							if [ -d "$folderName" ]; then
								read -e -p "Enter the groupname of the folders new group: " newGroup
								grep $newGroup /etc/group &> /dev/null
								if [ $? = 1 ]; then
									echo "This group does not exist!"
								else
									chgrp $newGroup $folderName
									if [ $? = 0 ]; then
										echo "Group for $folderName has been changed to $newgroup"
									fi
								fi
							else
								echo "This folder/directory does not exist!"
							fi
							echo -e "\nPress any button to continue"
							read -e -n 1
							
							;;
						3)
							PermVar=1
							while [ "$EXITVAR" -eq "1" ]; do
								clear
								echo "************************************"
								echo -e "\033[1mChange permissions\033[0m"
								echo "************************************"
								echo -e "\033[1m\n1. Owner permissions \033[0m"
								echo -e "\033[1m2. Group permissions \033[0m"
								echo -e "\033[1m3. User permissions \033[0m"
								echo -e "\033[1m4. Back \033[0m"
								read -n 1 -p "Enter your option here: " USERCHOICE
								clear

								case $USERCHOICE in
									1)
										accessChange=""
										permissionLevel=""
										folderName=""
										echo "************************************"
										echo -e "\033[1mModify owner permissions\033[0m"
										echo "************************************"
										read -e -p $'\nEnter the folder name of the folder you wish to modify the permissions on: ' folderName
										if [ -d "$folderName" ]; then
											read -e -n 1 -p $'\ndo you wish to add (+),remove (-) or set (=) permissions?: ' accessChange
											case $accessChange in
												("" | *[!+-=]*)
													echo -e "\n\nInvalid input!" 
													echo -e "\nPress any button to continue"
													read -e -n 1							
													;;
												(*)
													read -e -n 3 -p $'\n\nEnter the permissions you wish to change (example: rwx): ' permissionLevel
													case $permissionLevel in
														("" | *[!rwx]*)
															echo -e "\nInvalid input!"
															echo -e "\nPress any button to continue"
															read -e -n 1 
															;;
														(*)
															chmod u$accessChange$permissionLevel $folderName
															echo -e "\nPermissions changed"
															echo -e "\nPress any button to continue"
															read -e -n 1 
															;;
													esac											
													;;
											esac					
			
										else
											clear
											echo -e "\nDesired folder doesnt exist!"
											echo -e "\nPress any button to continue"
											read -e -n 1
										fi						
										;;
									2)
										accessChange=""
										permissionLevel=""
										folderName=""
										echo "************************************"
										echo -e "\033[1mModify group permissiond\033[0m"
										echo "************************************"
										read -e -p $'\nEnter the folder name of the folder you wish to modify the permissions on: ' folderName
										if [ -d "$folderName" ]; then
											read -e -n 1 -p $'\ndo you wish to add (+),remove (-) or set (=) permissions?: ' accessChange
											case $accessChange in
												("" | *[!+-=]*)
													echo -e "\n\nInvalid input!" 
													echo -e "\nPress any button to continue"
													read -e -n 1							
													;;
												(*)
													read -e -n 3 -p $'\n\nEnter the permissions you wish to change (example: rwx): ' permissionLevel
													case $permissionLevel in
														("" | *[!rwx]*)
															echo -e "\nInvalid input!"
															echo -e "\nPress any button to continue"
															read -e -n 1 
															;;
														(*)
															chmod g$accessChange$permissionLevel $folderName
															echo -e "\nPermissions changed"
															echo -e "\nPress any button to continue"
															read -e -n 1 
															;;
													esac											
													;;
											esac					
			
										else
											clear
											echo -e "\nDesired folder doesnt exist!"
											echo -e "\nPress any button to continue"
											read -e -n 1
										fi
										;;
									3)
										accessChange=""
										permissionLevel=""
										folderName=""
										echo "************************************"
										echo -e "\033[1mModify user permissions\033[0m"
										echo "************************************"
										read -e -p $'\nEnter the folder name of the folder you wish to modify the permissions on: ' folderName
										if [ -d "$folderName" ]; then
											read -e -n 1 -p $'\ndo you wish to add (+),remove (-) or set (=) permissions?: ' accessChange
											case $accessChange in
												("" | *[!+-=]*)
													echo -e "\n\nInvalid input!" 
													echo -e "\nPress any button to continue"
													read -e -n 1							
													;;
												(*)
													read -e -n 3 -p $'\n\nEnter the permissions you wish to change (example: rwx): ' permissionLevel
													case $permissionLevel in
														("" | *[!rwx]*)
															echo -e "\nInvalid input!"
															echo -e "\nPress any button to continue"
															read -e -n 1 
															;;
														(*)
															chmod o$accessChange$permissionLevel $folderName
															echo -e "\nPermissions changed"
															echo -e "\nPress any button to continue"
															read -e -n 1 
															;;
													esac											
													;;
											esac					
			
										else
											clear
											echo -e "\nDesired folder doesnt exist!"
											echo -e "\nPress any button to continue"
											read -e -n 1
										fi
										;;
									4)
										PermVar=0
										;;
									*)
										echo "Invalid input"
										;;
								esac
							done
							;;
						
						4)
							folderName=""
							echo "************************************"
							echo -e "\033[1mApply sticky bit to a directory/folder\033[0m"
							echo "************************************"
							read -e -p "Enter the path and directory/filename to apply sticky bit" folderName
							if [ -d "$folderName" ]; then
								chmod +t $folderName
								if [ $? = 0 ]; then
									echo "Sticky bit has been applied to $folderName"
								else 
									echo "Something went wrong... Check your spelling and try again"
								fi
								
							else
								echo "This folder/directory does not exist!"
							fi
							echo -e "\nPress any button to continue"
							read -e -n 1
							;;
						5)
							folderName=""
							echo "************************************"
							echo -e "\033[1mApply setgid to a directory/folder\033[0m"
							echo "************************************"
							read -e -p "Enter the path and directory/filename to apply setgid" folderName
							if [ -d "$folderName" ]; then
								chmod g+s $folderName
								if [ $? = 0 ]; then
									echo "Setgid has been applied to $folderName"
								else 
									echo "Something went wrong... Check your spelling and try again"
								fi
								
							else
								echo "This folder/directory does not exist!"
							fi
							echo -e "\nPress any button to continue"
							read -e -n 1
							;;
						6)
							echo "************************************"
							echo -e "\033[1mLast edited folder on the system\033[0m"
							echo "************************************"
							echo -e "\n"
							# Find the last modified directory on the entire filesystem
							last_modified_dir=$(find / -type d -printf '%T+ %p\n' 2>/dev/null | sort -r | head -n 1)

							# Extract the directory path and modification time from the output of the find command
							dir_path=$(echo "$last_modified_dir" | awk '{print $2}')
							modification_time=$(echo "$last_modified_dir" | awk '{print $1}')

							# Extract the year, month, day, hour, and minute from the modification time
							year=$(echo "$modification_time" | cut -c 1-4)
							month=$(echo "$modification_time" | cut -c 6-7)
							day=$(echo "$modification_time" | cut -c 9-10)
							hour=$(echo "$modification_time" | cut -c 12-13)
							minute=$(echo "$modification_time" | cut -c 15-16)

							# Convert the modification time to a more readable format and round it up to the nearest minute
							modification_time=$(date -d "$year-$month-$day $hour:$minute" +"%Y-%m-%d %H:%M")
							echo -e "\033[1mThe last modified directory is:\033[0m $dir_path"
							echo -e "\033[1mThe modification time is:\033[0m $modification_time"
							
							echo -e "\nPress any button to continue"
							read -e -n 1
							;;

						7)
							DirVar=0
							;;
						*)
							echo "Invalid input"
							;;
					esac
				done
				;;
			4)
				folderName=""
				confirmed=""
				echo "************************************"
				echo -e "\033[1mDelete a directory or folder\033[0m"
				echo "************************************"
				echo "Use this format /path/foldername"
				read -e -p "Enter the path and name of the folder or directory you wish to delete (Enter just the folder name for current directory): " folderName
				if [ -d "$folderName" ]; then
						read -e -p "The folder/directory and everything in it will be deleted! Press y to continue or n to return: " confirmed
						clear
						echo "************************************"
						echo -e "\033[1mDelete a directory or folder\033[0m"
						echo "************************************"
						if [ $confirmed = "y" ]; then
							rm -r $folderName &> /dev/null
						fi
				else
					    echo "Error: Directory $folderName does not exists."
				fi			
				
				if [ $? -eq 0 ]; then
					echo "The folder $folderName has been deleted!"
				fi
				echo -e "\nPress any button to continue"
				read -n 1
				;;
			5)
				FolderVar=0
				;;
			*)
				echo "Invalid input";;
		esac
	done
}

UI
