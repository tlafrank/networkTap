#!/bin/bash
#Script used to deploy NTLC to a Ubuntu 18.04 Server.
#This is for bare metal. Multiple bridges and additional configuration will be required on the host/VM for this to work.

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

function main {
  #Check that the script is being run as SUDO.
  if [ "root" = $USER ]; then
    echo 'Script is running as SUDO, as expected.'
    echo 'Assumes transparent bridge has already been established'


    install_tshark
    install_ntlc

    #Configure NTLC


    enable_services

  else
    echo 'Script is not running as SUDO (required). Exiting with no changes.'
  fi
}

function install_tshark {
  #Ensure that the universe repo is available (not available by default on a server install)
  grep '^[^#]' /etc/apt/sources.list | grep ' universe' > /dev/null
  case $? in 
    0) echo -e "[ ${GREEN}SUCCESS${NC} ] Universe repo already available in sources";;
    1)
		#Universe repo was not found in sources, add the repo sources
	  	echo -e "[ ${YELLOW}NOTICE${NC} ] Universe repo is being added to sources"  

	    echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic universe" >> /etc/apt/sources.list
	    echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic-updates universe" >> /etc/apt/sources.list	
		case $? in 
    		0) echo -e "[ ${GREEN}SUCCESS${NC} ] Universe repo was successfully added to sources";;
    		*) echo -e "[ ${RED}FAILURE${NC} ] There was an unknown error whilst adding the universe repo to /etc/apt/sources.list";;
  		esac    
	;;
    *) echo -e "[ ${RED}FAILURE${NC} ] There was an unknown error whilst checking sources";;
  esac


  #Update
  apt-get -y update > /dev/null
  case $? in 
    		0) echo -e "[ ${GREEN}SUCCESS${NC} ] Sources updated";;
    		*) echo -e "[ ${RED}FAILURE${NC} ] There was an unknown error whilst trying to update sources";;
  esac

  #Install tshark, if it doesnt already exist
  dpkg -s tshark | grep 'Status'
  case $? in
  	0) echo -e "[ ${GREEN}SUCCESS${NC} ] Tshark is already installed";;
	1)
	  	apt-get -y install tshark
		case $? in 
    		*) echo -e "[ ${RED}FAILURE${NC} ] There was an unknown error whilst installing tshark";;
  		esac
	;;
    		0) echo -e "[ ${GREEN}SUCCESS${NC} ] Tshark installed";;
	*);;
  esac
}

function install_ntlc() {
	echo -e "[ ${YELLOW}NOTICE${NC} ] Deploying NTLC"
	#Stop any instances of tsharkd which might be running
	systemctl stop tsharkd.service


	#Setup the directory structure
	mkdir /opt/ntlc/ 2> /dev/null
	mkdir /opt/ntlc/data/ 2> /dev/null

	#Copy the files
	cp -f $DIR/components/ntlc/* /opt/ntlc/
	cp -f $DIR/components/tsharkd.sh /usr/local/bin/tsharkd.sh
	cp -f $DIR/components/tsharkd.service /etc/systemd/system/

	#chmod 775

	systemctl daemon-reload

}

function enable_services() {
	echo -e "[ ${YELLOW}NOTICE${NC} ] Starting tsharkd"

	#Configure ntlc
	#/opt/ntlc/configure.sh

	#Start tsharkd
	systemctl start tsharkd.service
	case $? in 
		0) echo -e "[ ${GREEN}SUCCESS${NC} ] Tshark was started";;
		*) echo -e "[ ${RED}FAILURE${NC} ] There was an unknown error whilst attempting to start tshark";;
	esac

	systemctl enable tsharkd.service

}

  #Install nodejs, for the web interface
  #apt-get install -y nodejs npm

  #Install node dependencies
  #npm install -g nodemon ejs

  #Samba, to allow access for the text editor
  #*** Want to avoid SAMBA, if possible. SHould be an option in case windows is used

  #apt-get install -y samba smbclient

  #Configure Samba for the root directory
  #[website]
  #  comment = nil
  #  path = /home/tlafrank/website
  #  read only = no
  #  browsable = yes
  #  create mask = 0700
  #  directory mask = 0700
  #  valid users = %S






main "$@"