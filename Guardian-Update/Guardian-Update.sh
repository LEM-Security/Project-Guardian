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

	#Checks if git is installed
	if ! [ -x "$(command -v git)" ]; then
		echo "Error: git is not installed." >&2
		exit 1
	fi

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

	mv Project-Guardian/Project\ Guardian\ Website/index_htm_files /var/www/html

	chown odroid:odroid /var/www/html/administration.htm

	chown odroid:odroid /var/www/html/index.htm

	chown odroid:odroid /var/www/html/help.htm

	chown odroid:odroid /var/www/html/index_htm_files

	echo "New website version installed!"

	echo "###################################################################"	

	sleep 5

	cat Project-Guardian/Change-Notes

	echo "Installation complete!"

else


	echo "Thank you, good bye"

	exit 1

fi
 
