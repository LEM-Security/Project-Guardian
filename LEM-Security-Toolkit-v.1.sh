#!/bin/bash

#############################################################################
#                    Created By: LEM Security LLC                           #
#	                        Started 07/08/2018                              #
#############################################################################

#clears the screen
clear

#Checks if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


#Creates the user interface
echo -e "\033[0;31m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\033[m"
echo -e "\033[0;31m+     _     _____ __  __ ____  _____ ____   _____           _ _    _ _      +\033[m"
echo -e "\033[0;31m+    | |   | ____|  \/  / ___|| ____/ ___| |_   _|__   ___ | | | _(_) |_    +\033[m"
echo -e "\033[0;37m+    | |   |  _| | |\/| \___ \|  _|| |       | |/ _ \ / _ \| | |/ / | __|   +\033[m"
echo -e "\033[0;37m+    | |___| |___| |  | |___) | |__| |___    | | (_) | (_) | |   <| | |_    +\033[m"
echo -e "\033[0;37m+    |_____|_____|_|  |_|____/|_____\____|   |_|\___/ \___/|_|_|\_\_|\__|   +\033[m"
echo -e "\033[0;34m+                    Created By: The LEM Security Team                      +\033[m"
echo -e "\033[0;34m+                                  Version 1.0                              +\033[m"
echo -e "\033[0;34m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\033[m"

read -p "Press enter to continue: "

#clears the screen
clear

#creates initial main menu
echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "+                   Main Menu               +"
echo "+       Choose what you would like to do?   +"
echo "+                                           +"
echo "+    1. Hashing                             +"
echo "+    2. Log/System Parsing                  +"
echo "+    3. DNS Server Configuration            +"
echo "+    4. System Administration               +"
echo "+    5. Firewall Configuration              +"
echo "+    6. Website Administration              +"
echo "+    7. Suricata IDS Configuration          +"
echo "+    8. DHCP Server Configuration           +"
echo "+    9. Drive Wipe                          +"
echo "+   10. Restart Device                      +"
echo "+   11. Shutdown Device                     +"
echo "+                                           +"
echo "+++++++++++++++++++++++++++++++++++++++++++++"

read -p "Please pick a number: " answer

clear


if [ "$answer" == "1" ]; then

	#creates hashing menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+               Hashing Menu                +"
	echo "+                                           +"
	echo "+            1. MD5                         +"
	echo "+            2. sha256                      +"
	echo "+            3. sha512                      +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " hashing

	clear

	case "$hashing" in
	#Gets the MD5 hash and the dates modified of the directory 

	1)
		find -L -type f -printf '%Tc %p\n' -exec md5sum "{}" \; >> md5sum.md5


		md5sum -c md5sum.md5 >> checklog.md5


		chmod 0444 md5sum.md5


		echo "Files hashed using MD5"

		;;


	2)
	#Gets the sha256 hash and the dates modified of the directory 

		find -L -type f -printf '%Tc %p\n' -exec sha256sum "{}" \; >> sha256sum.sha256


		sha256sum -c sha256sum.sha256 >> checklog.sha256


		chmod 0444 sha256sum.sha256


		echo "Files hashed using sha256"

		;;

	3)
	#Gets the sha512 hash and the dates modified of the directory 

		find -L -type f -printf '%Tc %p\n' -exec sha512sum "{}" \; >> sha512sum.sha512


		sha512sum -c sha512sum.sha512 >> checklog.sha512


		chmod 0444 sha512sum.sha512
	

		echo "Files hashed using sha512"

		;;
		
	*) 

		echo "Error! Unknown option, please try again."
		
		exit 1
		
		;;
	
	esac
	
fi

if [ "$answer" == "2" ]; then

	#creates parsing menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+        Log/System Parsing Menu            +"
	echo "+                                           +"
	echo "+          1. Sudo Audits                   +"
	echo "+          2. Login Failures                +"
	echo "+          3. System Users                  +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " parsing

	clear

	
	case "$parsing" in
		#Parses for sudo attempts and failures
	
	1)
		echo "There were $(grep -c ' sudo: ' /var/log/auth.log) attempts to use sudo, $(grep -c ' sudo: .*authentication failure' /var/log/auth.log) of which failed."
	
		;;
	

	2)
	#Parses failed logins of all kinds as well as their IPs if they were remote

	   	file -r /var/log/auth.log			
	
		cat /var/log/auth.log | grep "Failed password for" | sed 's/[0-9]/1/g' | sort -u | tail >> Failed-Logins.txt
		
		echo "Failed logins written to file (Failed-Logins.txt) in your CWD"

		;;

	#Gets the users on the system 
	3) 

		cat /etc/passwd | grep /bin/bash 

		;;

	*)
	
		echo "Error! Unknown option, please try again."
		
		exit 1
		
		;;
	
	esac	
	
fi

if [ "$answer" == "3" ]; then

	#creates DNS setup menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+               DNS Menu                    +"
	echo "+                                           +"
	echo "+    1. Start DNS Server (default)          +"
	echo "+    2. Stop DNS Server                     +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " DNS

	clear

	case "$DNS" in
	#Starts the DNS server
	1)

		echo "Would you like to enable the DNS server at boot? (y/n)"
		
		read atboot
		
		if [ "$atboot" == "y" ]; then 
	
			systemctl start bind9 && systemctl enable bind9
			
			echo "DNS server started and will now run at boot"

		else
		
			echo "DNS server started"
			
			systemctl start bind9
			
		fi	
		;;

	#Stops the DNS server
	2)

		echo "Would you like to disable the DNS server at boot? (y/n)"
		
		read atboot1
		
		if [ "$atboot1" == "y" ]; then 
	
			systemctl stop bind9 && systemctl disable bind9
			
			echo "DNS server stopped and will no longer run at boot"

		else
		
			echo "DNS server stopped"
			
			systemctl stop bind9
			
		fi		
		
		;;
		
	*)
		echo "Error! Unknown option, please try again."
		
		exit 1
		
		;;

	esac	
	
fi

if [ "$answer" == "4" ]; then

	#creates system administration menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+        System Administration Menu         +"
	echo "+                                           +"
	echo "+    1. Create a user                       +"
	echo "+    2. Delete a user                       +"
	echo "+    3. Lock a user account                 +"
	echo "+    4. Unlock a user account               +"
	echo "+    5. Change User Password                +"
	echo "+    6. Add a user to group                 +"
	echo "+    7. Remove a user from group            +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " admin

	clear


	case "$admin" in
	#creates user
	1)

		echo "What would you like the username to be?"

		read username
		
		getent passwd $username > /dev/null

		if [ $? -eq 0 ]; then

			echo "user $username already exists!"

			exit 0		

		else

			echo "user $username does not exist, creating user!"

			useradd -m $username

			passwd $username
		
		fi		
		
		;;

	#Deletes a user
	2)

		cat /etc/passwd | grep /bin/bash | less

		echo "What user would you like to delete?"

		read deluser

		getent passwd $deluser > /dev/null

		if [ $? -eq 0 ]; then

			echo "user $deluser exists, deleting account!"

			userdel -r $deluser

		else

			echo "user $deluser does not exist!"

			exit 0	
		
		fi

		;;

	#Locks a user account
	3)
	
		cat /etc/passwd | grep /bin/bash | less

		echo "Which user would you like to lock?"

		read lock

		passwd $lock -l

		echo "Account $lock has been locked!" 

		;;
	
	#Unlocks a user account
	4)
	
		cat /etc/passwd | grep /bin/bash | less

		echo "Which user would you like to unlock?"

		read unlock

		passwd $unlock -u

		echo "Account $unlock has been unlocked!" 

		;;

	#Change a users password
	5)

		#lists current system users
		cat /etc/passwd | grep /bin/bash

		#asks the user the name of the user they want to change the password for
		echo "Which user would you like to change the password for?"

		#creates variable user
		read user

		#checks if the user exists
		getent passwd $user > /dev/null

		if [ $? -eq 0 ]; then

			echo "user $user exists!"

		else

			echo "user $user does not exist!"

			exit 0	

		fi

		#asks the user what they want the new password to be
		echo "What would you like the new password to be?"

		#creates variable password
		read password

		#changes selected users password
		echo "$user:$password" | chpasswd

		#tells user the password updated successfully
		echo "password changed successfully for user $user!"

		;;
	#adds a user to a group
	6)

		cat /etc/passwd | grep /bin/bash | less

		echo "Which user would you like to add to a group?"		

		read user

		clear

		cat /etc/group | less
		
		echo "Which group would you like to add $user to?"

		read group
	
		usermod -a -G $group $user 
		
		echo "$user has been added to the $group group!"

		;;
	#removes user from a group
	7)

		cat /etc/passwd | grep /bin/bash | less

		echo "Which user would you like to remove from a group?"		

		read user

		clear

		cat /etc/group | less
		
		echo "Which group would you like to remove $user from?"

		read group
	
		usermod -a -G $group $user 
		
		echo "$user has been removed from the $group group!"

		;;
		
	*)

		echo "Error! Unknown option, please try again."
		
		exit 1

		;;

	esac
	
fi


if [ "$answer" == "5" ]; then

	#creates IPtables menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+                Firewall Menu              +"
	echo "+                                           +"
	echo "+    1. Flush Configuration                 +"
	echo "+    2. Show Configuration                  +"
	echo "+    3. Add Rules                           +"
	echo "+    4. Set Policy to DROP                  +"
	echo "+    5. Set Policy to ALLOW                 +"
	echo "+    6. Save Configuration                  +"	
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " iptables

	clear
	
	case "$iptables" in
	#Flushes table and chain
	1)
	
		iptables -X
		iptables -F

		;;

	#Lists iptables rules
	2)

		iptables -L

		;;

		#Adds rules
	3) 

		#Checks to see if iptables is installed
		if ! [ -x "$(command -v iptables)" ]; then
		echo "Error: iptables is not installed." >&2
		exit 1
		fi
		
		read -p "Would you like to block or allow a port? (block/allow): " port
		
		clear 
		
		case $port in
		
		allow)	
				echo "What port would you like to allow? ie. 80"
				read pnumber1
			
				clear
			
				echo "Is the port UDP or TCP?"
				read protype1
			
				clear
			
				echo "Is this an inbound or outbound rule? (INPUT/OUTPUT)"
				read aa
				
				iptables -t filter -A $aa -p $protype1 --dport $pnumber1 -j ACCEPT
				
				;;
		block)
				echo "What port would you like to block? ie. 80"
				read pnumber2
			
				clear
			
				echo "Is the port UDP or TCP?"
				read protype2
			
				clear
			
				echo "Is this an inbound or outbound rule? (INPUT/OUTPUT)"
				read bb
				
				iptables -t filter -A $bb -p $protype2 --dport $pnumber2 -j DROP		
				;;
			*)
				echo "Error! Unknown option, please try again."
				exit 1
				;;
		
		esac
		
		;;

	#Sets policy to drop
	4)

		iptables -t filter -P INPUT DROP

		iptables -t filter -P FORWARD DROP

		iptables -t filter -P OUTPUT DROP
		
		;;
			
	#Sets policy to allow
	5)

		iptables -t filter -P INPUT ACCEPT

		iptables -t filter -P FORWARD ACCEPT

		iptables -t filter -P OUTPUT ACCEPT

		;;
	
	#Saves current configuration
	6)
	
		/etc/init.d/iptables-persistent save 

		;;
		
	*)

		echo "Error! Unknown option, please try again."
		
		exit 1
		
		;;

	esac	
fi

if [ "$answer" == "6" ]; then

	#Change website password menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+        Website Administration Menu        +"
	echo "+                                           +"
	echo "+    1. Change Website Password             +"
	echo "+                                           +"
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " chwebpasswd
	
	clear
	
	case "$chwebpasswd" in

	1)
		htpasswd /etc/nginx/.htpasswd projectguardian
		
		;;

	*)
		echo "Error! Unknown option, please try again."
		
		exit 1

		;;

	esac

fi


if [ "$answer" == "7" ]; then

	#Suricata IDS Configuration menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+          Suricata IDS Menu                +"
	echo "+                                           +"
	echo "+    1. Start Suricata (default)            +"
	echo "+    2. Enable a Rule                       +"
	echo "+    3. Disable a Rule                      +"
	echo "+                                           +"
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " suricata
	
	clear
	
	case "$suricata" in
	
	1)
		suricata -c /etc/suricata/suricata.yaml -i eth0
	
		;;
	

	2)	
		echo "What is the SID for the rule you want to enable?"
		
		read sid

		sed -i '$ a enablesid $sid' /etc/oinkmaster.conf

		oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules

		suricata -c /etc/suricata/suricata.yaml -i eth0

		;;
			
	3)
		echo "What is the SID for the rule you want to disable?"

		read sid

		sed -i '$ a disablesid $sid' /etc/oinkmaster.conf

		oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules

		suricata -c /etc/suricata/suricata.yaml -i eth0

		;;
	*)
		
		echo "Error! Unknown option, please try again."
		
		exit 1
		
		;;
		
	esac
fi	
	
if [ "$answer" == "8" ]; then

	#creates DHCP setup menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+               DHCP Menu                   +"
	echo "+                                           +"
	echo "+    1. Start DHCP Server (default)         +"
	echo "+    2. Stop DHCP Server                    +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " DHCP

	clear

	case "$DHCP" in
	#Starts the DHCP server
	1)

		echo "Would you like to enable the DHCP server at boot? (y/n)"
		
		read atboot
		
		if [ "$atboot" == "y" ]; then 
	
			systemctl start isc-dhcp-server && systemctl enable isc-dhcp-server
			
			echo "DHCP server started and will now run at boot"

		else
		
			echo "DHCP server started"
			
			systemctl start isc-dhcp-server
			
		fi	
		;;

	#Stops the DHCP server
	2)

		echo "Would you like to disable the DHCP server at boot? (y/n)"
		
		read atboot1
		
		if [ "$atboot1" == "y" ]; then 
	
			systemctl stop isc-dhcp-server && systemctl disable isc-dhcp-server
			
			echo "DHCP server stopped and will no longer run at boot"

		else
		
			echo "DHCP server stopped"
			
			systemctl stop isc-dhcp-server
			
		fi		
		
		;;
		
	*)
		echo "Error! Unknown option, please try again."
		
		exit 1
		
		;;

	esac	
	
fi

if [ "$answer" == "9" ]; then

	#creates drive wipe menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+              Drive Wipe Menu              +"
	echo "+                                           +"
	echo "+    1. Secure Drive Wipe                   +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " drive

	clear

	case "$drive" in
	#Wiping the entire drive
	1)	

		echo "What is the path of the drive you want to wipe? (/dev/****) or run (lsblk) to see all drive paths"

		read letter

		echo "Are you sure you want to entirely wipe the drive /dev/$letter? This is not reversable. (y/n)"

		read check2	

		if [ "$check2" == "y" ]; then 
		
			echo "Wiping drive, this will take a while"
	
			dd if=/dev/zero of=/dev/$letter bs=1M
	
		else

			exit 0

		fi

		;;
		
	*)

		echo "Error! Unknown option, please try again."
		
		exit 1
		
		;;

	esac
	
fi

#Reboots the Device
if [ "$answer" == "10" ]; then

	echo "System will restart in 5 seconds"
	
	sleep 5
	
	reboot
fi

#Shutsdown the device
if [ "$answer" == "11" ]; then
	
	echo "System will shutdown in 5 seconds"
	
	sleep 5
	
	poweroff 

fi
