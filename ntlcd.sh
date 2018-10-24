#!/bin/bash
#Place in /usr/local/bin/ntlcd.sh

#Define interface names
IFUPSTREAM="if-upstream"
IFDOWNSTREAM="if-downstream"

function d_start ( )
{
        echo  "ntlcd: Starting service"
#Delete any existing qdiscs
        tc qdisc delete dev $IFUPSTREAM root netem 2> /dev/null
        tc qdisc delete dev $IFDOWNSTREAM root netem 2> /dev/null

#Create qdisc netem file
        tc qdisc add dev $IFUPSTREAM root netem delay 0ms
        tc qdisc add dev $IFDOWNSTREAM root netem delay 0ms

#Create a file to record the status of the qdisc
        echo "Nil" > /tmp/ntlcd.status

}

function d_stop ( )
{
        tc qdisc delete dev $IFUPSTREAM root netem 2> /dev/null
        tc qdisc delete dev $IFDOWNSTREAM root netem 2> /dev/null

        rm  /tmp/ntlcd.status
}

function d_status ( )
{
        echo  "No status relevant for ntlcd.service"
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
