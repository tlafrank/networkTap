#!/bin/bash
#Configures the NTLC after deployment

function main {
  #Check that the script is being run as SUDO.
  if [ "root" = $USER ]; then
    echo 'Script is running as SUDO, as expected.'
 
    conf_ntlc

  else
    echo 'Script is not running as SUDO (required). Exiting with no changes.'
  fi

}


#Updates ntlc.conf
function conf_ntlc {

  #Configure the interfaces to use for NTLC
  echo 'Select UPSTREAM interface'
  select upstream in $(nmcli -t dev | awk -F : '{print $1}')
  do
    sed -e 's/^IFUPSTREAM/test/' ntlc.sh | grep 'STREAM'
  done

  echo 'Select DOWNSTREAM interface'
  select upstream in $(nmcli -t dev | awk -F : '{print $1}')
  do
    sed -e 's/^IFUPSTREAM/test/' ntlc.sh | grep 'STREAM'
  done



}


main "$@"