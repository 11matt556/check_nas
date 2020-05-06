#!/bin/bash

bad_ping=$(/usr/bin/ping -c 3 omv-nas.lan 2>&1| grep --count "100% packet loss\|failure")

echo $bad_ping

if [ $bad_ping = 1 ]; then
   echo "Server down"
   echo "Stopping docker transmission container"
   docker stop transmission
   echo "Unmounting /mnt/media"
   umount /mnt/media
else
   echo "Server up"
   echo "Attempting to mount network share"
   mount=$(mount.cifs //omv-nas.lan/Media /mnt/media -o credentials=/root/.smbcred,uid=5001,gid=5001 0 0 2>&1| grep --count "Device or resource busy")
   echo $mount
   if [ $mount = 0 ]; then
        echo "Mount suceeded. Starting transmission"
        docker=$(docker start transmission)
        echo $docker
   else
     echo "Mount failed"
   fi
fi