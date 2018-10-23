#!/bin/bash
#place in TBA /usr/local/bin/

function d_start ( )
{
	echo  "ntlcd: Starting service"
	#tshark -b filesize:10240 -w /var/tsharkCapture &
	#echo $! > /tmp/tsharkd.pid
	sleep  5
	#echo  "PID is $(cat /tmp/tsharkd.pid) "
}

function d_stop ( )
{
	echo  "Tsharkd: stopping Service (PID = $(cat /tmp/tsharkd.pid) )"
	kill $(cat /tmp/tsharkd.pid)
	rm  /tmp/tsharkd.pid
}

function d_status ( )
{
	#ps  -ef  |  grep deluged |  grep  -v  grep
	echo  "PID indicate indication file $(cat /tmp/tsharkd.pid 2&> /dev/null)"
}

# Some Things That run always
#touch  / var / lock / deluge

# Management instructions of the service
case $1 in
	start )
		d_start
		;;
	stop )
		d_stop
		;;
	reload )
		d_stop
		sleep  1
		d_start
		;;
	status )
		d_status
		;;
	* )
		echo $1
		echo  "Usage: $0 {start | stop | reload | status}"
	exit  1
	;;
esac

exit  0
