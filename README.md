# networkTap
Configure a system to act as a network tap and line conditioner

## How it works

### setup.sh
The list of actions required to configure a Ubuntu 18.04 machine. Requires work as it is not in any condition to run as a shell script in its entierty.

### ntlcd.service
The ntlc daemon launches on system boot. This sets up an empty netem qdisc, so that there is no requirement to test and jump between 'tc qdisc add' and 'tc qdisc change'. Additionally, it commences a tshark capture and launches the web interface server.

### ntlcd.sh
The NTLC daemon launched by ntlcd.service.

### ntlc.sh
This script handles the changing of the netem qdisc as well as switching the tshark capture on or off. It is executed through user interaction on the web interface. 

Usage:
ntlc.sh [OPTION]

OPTIONS
--tshark [on|off]
            Control tshark capture. Displays current tshark state if on|off are not provided.
-condition [off|1|2|3|4]
            Apply/disable/display link conditioning. Where conditions are:
            1   EPLRS Best Case
            2   25kHz SATCOM (16kbit)
            3   Inmarsat GX (5Mbit UP / 50Mbit DOWN)
            4   Inmarsat BGAN (492kbit)
            No arguements returns the currently configured condition
