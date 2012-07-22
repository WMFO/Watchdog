#!/bin/bash
#Test suite for Watchdog
#Slightly hacked together (no single point of truth between this test and the
#script itself)

unmount -t cifs //192.168.0.210/Rivendell-Super /var/snd
unmount -t cifs //192.168.0.210/tobeImported-Super /var/import
unmount -t cifs //192.168.0.210/Backup-Super /var/backup

/etc/init.d/rivendell stop
/etc/init.d/webstream stop
kill `ps -eo pid,args | grep listenbot | grep -v grep | cut -c1-6`

ifconfig eth0 down
ifconfig eth1 down
