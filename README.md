Watchdog
========
WMFO - Tufts Freeform Radio  
ops@wmfo.org  
For copyrights and licensing, see COPYING.

A watchdog script to make sure the webstream processes are running, that the
rivendell shares are mounted, and the NICs are conencted to the network.

Usage: `watchdog2.sh <log_file>`

It is recomended you place something similar to the following 
in root's crontab (`sudo crontab -e`):  
`@reboot /opt/wmfo/watchdog/watchdog2.sh /var/log/watchdog2.log`

Changelog
---------
###??/??/??
Initial version. - Benjamin Yu

###10/23/11
Made log file far less verbose. Now logs only on errors.
Includes date. - Andy Sayler

###10/24/11
Branched from watchdog.sh to watchdog2.sh - Andy Sayler

###10/24/11
Added automatic unmounting on detection of multiple mounts. - Andy Sayler

###10/24/11
Refactored to mount and unmount on mount point names,
not network paths. This should avoid needing to change
this script when switching between primary and secondary
network data stores. Just change the mount device
path in /etc/fstab and the changes will be reflected here.
If mount points are changed, this script will still need
modified. - Andy Sayler

###07/07/12
Add checks to restart external and internal NICs in case no IP
is detected. This assumes that, under normal operation, 
eth0 has a 192.168 address and eth1 has a 130.64 (Tufts network)
address. - Max Goldstein

###08/11/12
Make NIC handling code smarter. Now runs only every 30 seconds,
stops trying to handle it after 3 consecutive failures, and does
nothing on restart until the NIC has connected successfully. - Max Goldstein
