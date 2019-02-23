#!/bin/bash

#File used to setup the system. 18.04 Server.
#This is for bare metal. Multiple bridges and additional configuration will be required on the host/VM for this to work.



function update {

  echo 'Updating'
  #Install updates
  #apt update -y
  #apt upgrade -y

}

function configure_transparent_bridge {
  echo 'Commencing configuration of transparent bridge'
 #Install bridge-utils
  #Not sure if required

  #Configure netplan yaml file. Assumes three interfaces, one for out-of-band management, and the others as the up and downstream ports of the NTLC.
  #Get network interfaces
  
  #network:
  #  version: 2
  #  ethernets:
  #    ens3:
  #      addresses:
  #        - 10.0.1.14/24
  #      dhcp4: false
  #      gateway4: 10.0.1.1
  #      nameservers:
  #       addresses:
  #         - 8.8.8.8
  #       search: []
  #    ens9:
  #      match:
  #        macaddress: 52:54:00:4c:43:36
  #      set-name: if-upstream
  #      dhcp4: no
  #    if-downstream:
  #      match:
  #        macaddress: 52:54:00:4c:43:37
  #      set-name: if-downstream
  #      dhcp4: no
  #  bridges:
  #    br0:
  #      interfaces:
  #        - ens9
  #        - if-downstream
  #      dhcp4: no

  #netplan apply
}

function install_tshark {
  #Ensure that the universe repo is available (not available by default on a server install)
  grep '^[^#]' /etc/apt/sources.list | grep ' universe' > /dev/null

  if [ $? -eq 0 ]; then
    #Universe repo was not found in sources, add the repo sources
    echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic universe" >> /etc/apt/sources.list
    echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic-updates universe" >> /etc/apt/sources.list
  fi

  #Install tshark
  apt-get install -y tshark
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




#Check that the script is being run as SUDO.
if [ "root" = $USER ]; then
  clear
  echo 'Script is running as SUDO, as expected.'
  echo 'Assumes transparent bridge has already been established'


  update
  configure_transparent_bridge





  PS3="Choice: "

  select opt in \
    'Update/Upgrade'\
    'Install tShark'\
    'TBA'\
    'TBA'\
    'Exit'
  do
    case $opt in
      'Update/Upgrade') update;;
      'Install tShark') install_tshark;;
      *)
        exit;
        break;
      ;;
    esac
  done
else
  echo 'Script is not running as SUDO (required). Exiting with no changes.'
fi


