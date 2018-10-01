#File used to setup the system. 18.04 Server. 

#Install updates
apt-get update -y
apt-get upgrade -y

#NOTE: As per https://bugs.launchpad.net/ubuntu/+source/nplan/+bug/1736975, netplan.io  (netplan.io/bionic-updates 0.36.3 amd64) does not automatically start at boot. This should be fixed in the next revision (Not before 7 Oct 18). Apply the update from bionic-proposed until then.


#Install bridge-utils

#Configure netplan yaml file
#network:
#    version: 2
#    renderer: networkd
#    ethernets:
#        enp3s0:
#            addresses: []
#            dhcp4: true
#            optional: true
#        enp5s0:
#            addresses: []
#            dhcp4: true
#            optional: true
#    bridges:
#      br0:
#        addresses: [10.0.1.20/24]
#        gateway4: 10.0.1.1
#        nameservers:
#          addresses: [8.8.8.8]
#        interfaces:
#          - enp3s0
#          - enp5s0
#        dhcp4: false

#Ensure that the universe repo is available (not available by default on a server install)
echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic universe" >> /etc/apt/sources.list
echo "deb http://au.archive.ubuntu.com/ubuntu/ bionic-updates universe" >> /etc/apt/sources.list

#Install tshark
apt-get install -y tshark

#Install nodejs, for the 
apt-get install -y nodejs npm

#Install shelljs, to allow nodejs to execute shell commands
npm install shelljs

npm install -g nodemon

npm install ejs

#Samba, to allow access for the text editor
apt-get install -y samba smbclient

#Configure Samba for the root directory
[homes]
   comment = Home Directories
   browseable = yes
   read only = no
   create mask = 0700
   directory mask = 0700
   valid users = %S

#Setup screen
echo 'hardstatus alwayslastline "%= %3n %t%? [%h]%? %="' >> ~/.screenrc
echo 'caption always "%= %-w%L>%{= BW}%n*%t%{-}%52<%+w %L="'  >> ~/.screenrc




