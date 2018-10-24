#File used to setup the system. 18.04 Server.
#This is for bare metal. Multiple bridges and additional configuration will be required on the host/VM for this to work.

#Install updates
apt-get update -y
apt-get upgrade -y

#NOTE: As per https://bugs.launchpad.net/ubuntu/+source/nplan/+bug/1736975, netplan.io  (netplan.io/bionic-updates 0.36.3 amd64) does not automatically start at boot. This should be fixed in the next revision (Not before 7 Oct 18). Apply the update from bionic-proposed until then.
#netplan.io/bionic-proposed,now 0.40.1~18.04.1 amd64 [installed] is used due to https://bugs.launchpad.net/netplan/+bug/1770082


#Install bridge-utils
#Not sure if required

#Configure netplan yaml file. Assumes three interfaces, one for out-of-band management, and the others as the up and downstream ports of the NTLC.
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

netplan apply

#Check that the configuration works

#Ensure that the universe repo is available (not available by default on a server install)
#Should update to check the presence first
echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic universe" >> /etc/apt/sources.list
echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic-updates universe" >> /etc/apt/sources.list

#Install tshark
apt-get install -y tshark

#Install nodejs, for the web interface
apt-get install -y nodejs npm

#Install node dependencies
npm install -g nodemon ejs

#Install shelljs, to allow nodejs to execute shell commands
#didnt end up using shelljs, used child_process instead
#npm install shelljs

#Samba, to allow access for the text editor
apt-get install -y samba smbclient

#Configure Samba for the root directory
#[website]
#  comment = nil
#  path = /home/tlafrank/website
#  read only = no
#  browsable = yes
#  create mask = 0700
#  directory mask = 0700
#  valid users = %S

#Setup screen (TBA if required)
echo 'hardstatus alwayslastline "%= %3n %t%? [%h]%? %="' >> ~/.screenrc
echo 'caption always "%= %-w%L>%{= BW}%n*%t%{-}%52<%+w %L="'  >> ~/.screenrc




