#!/bin/bash

############################################################
#           Script created by LEM Security LLC             #
#              For use with Project Guardian               #
#                       V.1 7/30/2018                      #
############################################################

#Forces to run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#Asks for user input
echo "Would you like to download the latest Project Guardian software release from LEM Security LLC? (y/n)" 

read answer

if [ "$answer" == "y" ]; then 


	echo "Checking Dependencies for Project Guardian"

	echo ""

	#Checks if git is installed
	if ! [ -x "$(command -v git)" ]; then
		echo "Error: git is not installed." >&2
		
		echo "Would you like to install git now? y/n"

		read answer
		
		case "$answer" in
	
		y)

			apt-get install -y git

			;;

		n)
			echo "Good bye"
			
			exit 1
			
			;;

		*)
			echo "Error! Unknown option, please try again."

			exit 1

			;;
		esac
		
	
	fi


	echo "Dependency check succeeded"

	echo "" 

	#Downloads latest version of software from github
        echo "###################################################################"

	git clone https://github.com/LEM-Security/Project-Guardian.git

        echo "###################################################################"

	#Makes permission changes as required and moves the files to proper locations
	chmod 777 Project-Guardian/LEM-Security-Toolkit/LEM-Security-Toolkit-v.1.sh

	mv Project-Guardian/LEM-Security-Toolkit/LEM-Security-Toolkit-v.1.sh /usr/local/bin/LEMSEC-TK

	echo "New LEMSEC-TK version installed!"

	echo "###################################################################"	

	sleep 5

	mv Project-Guardian/Project\ Guardian\ Website/administration.htm /var/www/html

	mv Project-Guardian/Project\ Guardian\ Website/index.htm /var/www/html

	mv Project-Guardian/Project\ Guardian\ Website/help.htm /var/www/html

	rm -r /var/www/html/index_htm_files 

	mv Project-Guardian/Project\ Guardian\ Website/index_htm_files /var/www/html

	chown odroid:odroid /var/www/html/administration.htm

	chown odroid:odroid /var/www/html/index.htm

	chown odroid:odroid /var/www/html/help.htm

	chown odroid:odroid /var/www/html/index_htm_files

	service nginx restart

	echo "New website version installed!"

	echo ""

	echo "###################################################################"

	echo ""

	cat Project-Guardian/Change-Notes

	echo ""

	echo "###################################################################"

	echo ""

	echo "Removing old files!"

	sleep 5

	rm -r Project-Guardian

	echo ""

	echo "Installation Complete!"
else


	echo "Thank you, good bye"

	exit 1

fi
 
