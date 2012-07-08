Watchdog
========

WMFO - Tufts Freeform Radio

Contact: ops@wmfo.org

A watchdog script to make sure the webstream is running and that the
rivendell shares are mounted.

Usage: watchdog2.sh <log_file>

For coprights and licensing, see COPYING.

Changelog
---------
###??/??/??
Initial version. - Ben Yu

###10/23/11
Made log file far less verbose. Now logs only on errors. 
Includes date. - Andy Sayler

###10/24/11
Branched from watchdog.sh to watchdog2.sh - A Sayler

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
