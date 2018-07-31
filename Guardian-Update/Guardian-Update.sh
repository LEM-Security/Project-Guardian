#!/bin/bash

#Forces to run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

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
chmod 777 Project-Guardian/LEM-Security-Toolkit-v.1/LEM-Security-Toolkit-v.1.sh

mv Project-Guardian/LEM-Security-Toolkit-v.1/LEM-Security-Toolkit-v.1.sh /usr/local/bin/LEMSEC-TK

echo "New LEMSEC-TK installed!"

sleep 5

mv Project-Guardian/Project\ Guardian\ Website/administration.htm /var/www/html

mv Project-Guardian/Project\ Guardian\ Website/index.htm /var/www/html

mv Project-Guardian/Project\ Guardian\ Website/help.htm /var/www/html

mv Project-Guardian/Project\ Guardian\ Website/index_htm_files /var/www/html

echo "New website version installed!"

sleep 5

cat Project-Guardian/Change-Notes

echo "Installation complete!"


 