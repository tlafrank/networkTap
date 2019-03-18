# networkTap
Configure a system to act as a network tap and line conditioner

## How it works

### deploy.sh
Copies the various files to their appropriate directories (/usr/local/bin, /opt/ntlc/), installs dependencies (tshark) and configures the bridge interface.

### components/ntlcd.service
The ntlc daemon launches on system boot. This sets up an empty netem qdisc, so that there is no requirement to test and jump between 'tc qdisc add' and 'tc qdisc change'. Additionally, it commences a tshark capture and launches the web interface server.

### components/ntlcd.sh
The NTLC daemon launched by ntlcd.service.

### components/ntlc/ntlc.sh
This script handles the changing of the netem qdisc as well as switching the tshark capture on or off. It is executed through user interaction on the web interface. Requires work.

### components/ntlc/ntlc.conf
Config settings for the NTLC. Read by tsharkd.sh (confirm this).

### components/ntlc/configure.sh
Placeholder for configuring the bridge. Bridge configuration from deploy.sh will be moved here eventually.


Ignore for now:
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
