#!/bin/bash
# Watchdog
#
# For documentation, see README.md
# For copyright and licensing, see COPYING

#NIC constants
nic_external_ip=`echo 130.64`
nic_external_eth=`echo eth1`
nic_internal_ip=`echo 192.168`
nic_internal_eth=`echo eth0`

check_status ()
{
    # Check for the shoutcast server, shoutcast transcoder,
    # and listenbot for archives.
    start-stop-daemon --stop -t --exec /srv/shoutcast/sc_trans_linux > /dev/null
    sc_trans=$?
    start-stop-daemon --stop -t --exec /srv/shoutcast/sc_serv > /dev/null
    sc_serv=$?
    start-stop-daemon --stop -t --exec /srv/shoutcast/listenbotv2 > /dev/null
    listenbot=$?

    #Check to see if the rivendell shares are mounted, and if so, how many times.
    var_snd_cnt=`mount -l | grep /var/snd | wc -l`
    var_import_cnt=`mount -l | grep /var/import | wc -l`
    var_backup_cnt=`mount -l | grep /var/backup | wc -l`

    #Do the same for the NICs
    nic_external_count=`ifconfig | grep $nic_external_ip | wc -l`
    nic_internal_count=`ifconfig | grep $nic_internal_ip | wc -l`

    #Check to see if rivendell daemons are running.
    test -e /var/run/rivendell/caed.pid
    caed=$?
    test -e /var/run/rivendell/ripcd.pid
    ripcd=$?
    test -e /var/run/rivendell/rdcatchd.pid
    rdcatchd=$?
}

handle_status ()
{
    rd_daemons=`expr $caed + $ripcd`
    rd_daemons=`expr $rd_daemons + $rdcatchd`
    if test 0 -ne $rd_daemons
    then
            echo `date` >> $log_file
        echo "Rivendell daemons are not running. Restarting..." >> $log_file
        /etc/init.d/rivendell restart
    fi

    shoutcast=`expr $sc_trans + $sc_serv`
    if test 0 -ne $shoutcast
    then
                echo `date` >> $log_file
        echo "Shoutcast is not running. Restarting..." >> $log_file
        /etc/init.d/webstream restart
    fi

    if test 0 -ne $listenbot
    then
                echo `date` >> $log_file
        echo "Listenbot is not running. Restarting..." >> $log_file
        start-stop-daemon --start --oknodo --background --exec "/opt/wmfo/watchdog/start-listenbot.sh"
    fi

    # --- Handle var/snd mount issues ---

    while [ $var_snd_cnt -gt 1 ]
    do
        echo `date` >> $log_file
        echo "/var/snd is mounted more than once. Unmounting..." >> $log_file
        umount /var/snd
        var_snd_cnt=`mount -l | grep /var/snd | wc -l`
    done

    if [ $var_snd_cnt -lt 1 ]
    then
        echo `date` >> $log_file
        echo "/var/snd is not mounted. Mounting..." >> $log_file
        mount /var/snd
        var_snd_cnt=`mount -l | grep /var/snd | wc -l`
    fi

        # --- Handle var/import mount issues ---

    while [ $var_import_cnt -gt 1 ]
    do
        echo `date` >> $log_file
        echo "/var/import is mounted more than once. Unmounting..." >> $log_file
        umount /var/import
        var_import_cnt=`mount -l | grep /var/import | wc -l`
    done

    if [ $var_import_cnt -lt 1 ]
    then
        echo `date` >> $log_file
        echo "/var/import is not mounted. Mounting..." >> $log_file
        mount /var/import
        var_import_cnt=`mount -l | grep /var/import | wc -l`
    fi

       # --- Handle var/backup mount issues ---

    while [ $var_backup_cnt -gt 1 ]
    do
        echo `date` >> $log_file
        echo "/var/backup is mounted more than once. Unmounting..." >> $log_file
        umount /var/backup
        var_backup_cnt=`mount -l | grep /var/backup | wc -l`
    done

    if [ $var_backup_cnt -lt 1 ]
    then
        echo `date` >> $log_file
        echo "/var/backup is not mounted. Mounting..." >> $log_file
        mount /var/backup
        var_backup_cnt=`mount -l | grep /var/backup | wc -l`
    fi

    # --- Handle external NIC issues ---

    if [ $nic_external_count -lt 1 ]
    then
        echo `date` >> $log_file
        echo "The external NIC has no IP. Resetting..." >> $log_file
        ifconfig $nic_external_eth down
        ifconfig $nic_external_eth up
        nic_external_count=`ifconfig | grep $nic_external_ip  | wc -l`
    fi


    if [ $nic_internal_count -lt 1 ]
    then
        echo `date` >> $log_file
        echo "The internal NIC has no IP. Resetting..." >> $log_file
        ifconfig $nic_internal_eth down
        ifconfig $nic_internal_eth up
        nic_internal_count=`ifconfig | grep $nic_internal_ip  | wc -l`
    fi
}

if test -n $1
then
    log_file=$1
fi

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

sleep 10

while test 0 -eq 0
do
        # Setup log file
    if test -z $log_file
    then
        log_file=/dev/null
    fi

    # Run and handle system checks
    check_status
    handle_status

    # Sleep for 10 seconds
    sleep 10
done
