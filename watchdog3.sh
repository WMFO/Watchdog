#!/bin/bash
# Watchdog
#
# For documentation, see README.md
# For copyright and licensing, see COPYING

#NIC constants

check_status ()
{
    # Check for the shoutcast server, shoutcast transcoder,
    # and listenbot for archives.
    #start-stop-daemon --stop -t --exec /srv/shoutcast/sc_trans_linux > /dev/null
    #sc_trans=$?
    #start-stop-daemon --stop -t --exec /srv/shoutcast/sc_serv > /dev/null
    #sc_serv=$?
    #start-stop-daemon --stop -t --exec /srv/shoutcast/listenbotv2 > /dev/null
    #listenbot=$?

    #Check to see if the rivendell shares are mounted, and if so, how many times.
    var_snd_cnt=`mount -l | grep /var/snd | wc -l`
    var_import_cnt=`mount -l | grep /var/import | wc -l`
    var_backup_cnt=`mount -l | grep /backup | wc -l`


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
    fi

       # --- Handle var/backup mount issues ---

    while [ $var_backup_cnt -gt 1 ]
    do
        echo `date` >> $log_file
        echo "/backup is mounted more than once. Unmounting..." >> $log_file
        umount /backup
        var_backup_cnt=`mount -l | grep /backup | wc -l`
    done

    if [ $var_backup_cnt -lt 1 ]
    then
        echo `date` >> $log_file
        echo "/backup is not mounted. Mounting..." >> $log_file
        mount /backup
    fi

}

handle_NICs ()
{
    # --- Handle external NIC issues ---

    if [ $nic_external_count -lt 1 ] && [ $nic_external_tries -lt $nic_timeout ]
    then
        echo `date` >> $log_file
        echo "The external NIC has no IP. Resetting..." >> $log_file
        ifdown $nic_external_eth
        ifup   $nic_external_eth
        let nic_external_tries+=1
    fi

    if [ $nic_external_count -gt 0 ]
    then
        let nic_external_tries=0
    fi

    # --- Handle internal NIC issues ---

    if [ $nic_internal_count -lt 1 ] && [ $nic_internal_tries -lt $nic_timeout ]
    then
        echo `date` >> $log_file
        echo "The internal NIC has no IP. Resetting..." >> $log_file
        ifdown $nic_internal_eth
        ifup   $nic_internal_eth
        let nic_internal_tries+=1
    fi

    if [ $nic_internal_count -gt 0 ]
    then
        let nic_internal_tries=0
    fi
}

if test -n $1
then
    log_file=$1
fi

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

let nic_step=0

echo `date` >> $log_file
echo "Watchdog has been restarted." >> $log_file

sleep 10

while test 0 -eq 0
do
    if test -z $log_file
    then
        log_file=/dev/null
    fi

    check_status >> $log_file 2>&1
    handle_status >> $log_file 2>&1

    #Check NICs less often
   # if [ $nic_step -eq 0 ]
   # then
   #     handle_NICs >> $log_file 2>&1
   # fi
   # let nic_step+=1
   # let nic_step%=3

    sleep 10
done
