#!/bin/bash
#Place in /usr/local/bin/tsharkd.sh
#Linked to by tsharkd.service

LOG_DIR=/var/tsharkCapture
FILE_PREFIX=log
FILE_SIZE=10240
CONF_FILE=/opt/ntlc/ntlc.conf
INTERFACE="br-ntlc"

function d_start ( )
{
        #Check to see if a NTLC configuration file exists, if so, read the log directory from it
        echo  "Tsharkd: starting service"
        if [ -e $CONF_FILE ]; then
		#Get ntlc settings from the conf file
                LOG_DIR=$(grep 'pcap_path' $CONF_FILE | awk -F\= '{print $2}')
                FILE_PREFIX=$(grep 'filename_prefix' $CONF_FILE | awk -F\= '{print $2}')

                #Add a random value, to track which files are in a sequence
                FILE_PREFIX="${FILE_PREFIX}_${RANDOM}"

                #Get the default capture file size
                FILE_SIZE=$(grep 'file_size' $CONF_FILE | awk -F\= '{print $2}')

		#Get interface
		#INTERFACE=

                #Make sure the directory variable is finished with a /
                sed '/\/$/q2' $LOG_DIR
                if [[ $? -eq 0 ]]; then
                        LOG_DIR="$LOG_DIR/"
                fi
        fi

        echo "Recording to $LOG_DIR"
        tshark -i $INTERFACE -b filesize:"$FILE_SIZE" -w "$LOG_DIR$FILE_PREFIX" &
        echo $! > /tmp/tsharkd.pid
        echo "$(date) Creating $LOG_DIR$FILE_PREFIX" >> /var/log/tsharkd.log
        sleep  1
        echo  "PID is $(cat /tmp/tsharkd.pid) "
}

function d_stop ( )
{
        echo  "Tsharkd: stopping Service (PID = $(cat /tmp/tsharkd.pid) )"
        kill $(cat /tmp/tsharkd.pid)
        rm  /tmp/tsharkd.pid

        #Add copy files here?
        /opt/ntlc/move_captures.sh
        
}

function d_status ( )
{
        ps  -ef  |  grep tshark |  grep  -v  grep
        echo  "PID indicate indication file $(cat /tmp/tsharkd.pid 2&> /dev/null)"
}

# Some Things That run always
#touch  / var / lock / deluge

# Management instructions of the service
case $1 in
        start ) d_start;;
        stop ) d_stop;;
        reload )
                d_stop
                sleep  1
                d_start
                ;;
        status ) d_status;;
        * )
                echo $1
                echo  "Usage: $0 {start | stop | reload | status}"
        exit  1
        ;;
esac

exit  0
