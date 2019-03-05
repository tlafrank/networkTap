#!/bin/bash
#Moves any unopened 

DIR_DEST=/mnt/host/captures/
DIR_SOURCE=/opt/ntlc/data/

function main {
  #Check that the script is being run as SUDO.
  if [ "root" = $USER ]; then
    echo 'Script is running as SUDO, as expected.'

    #Create the destination directory
	mkdir $DIR_DEST
    
	#For each file in the source directory, check that it is not currently open (I.e. isn't currently a file under capture)
	for filename in $DIR_SOURCE/*; do
		lsof -a $filename > /dev/null
		if [[ $? -eq 1 ]]; then
			#File is not locked
			
			chown nobody:nogroup $filename
			chmod 666 $filename

			mv $filename $DIR_DEST
		fi
	done
  else
    echo 'Script is not running as SUDO (required). Exiting with no changes.'
  fi



}



main "$@"