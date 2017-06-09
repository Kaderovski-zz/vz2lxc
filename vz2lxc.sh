#!/bin/bash
#===============================================================================
#
#          FILE: migrate.sh
#
#         USAGE: ./migrate.sh [ID] [IP]
#
#   DESCRIPTION: Small migration script vz to lxc
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Corentin (DevOps Engineer & Programmer)
#       CREATED: 09/06/2017 12:35:02
#      REVISION:  ---
#===============================================================================

if [[ $EUID -eq 0 ]]; then
   echo "This script must NOT be run as root" 1>&2
   exit 1
fi

# Taking args
ID=$1
rIP=$2                                     # Remote IP

# Vars
USER=""
rUser=""
rPort=                                     # Remote port scp
rPath="/var/lib/vz/template/cache/"        # Remote path scp
destDump="/home/$USER/vzdump/"

# Check for ID 
if [ -z $ID ] ; then
    echo 'No vz ID passed'
    exit
elif [[ ! $ID =~ ^[0-9]+$ ]]; then
    echo "$ID: expecting a number"
    exit 
fi

# Check for IP
if [ -z $rIP ] ; then
    echo 'No IP passed'
    exit
elif [[ ! $rIP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "$rIP: expecting IP"
    exit 
fi

#################
# Work on VZ_ID #
#################
# Destination dump
sudo mkdir -p $destDump

# Stop & Dump
sudo vzctl stop $ID && echo "$ID stopped [OK]" && sudo vzdump $ID -dumpdir /home/$USER/vzdump && echo "$ID : dump [OK]"

# DumpName
vzDumpName=$(ls /home/$USER/vzdump/)

# scp to new server
cd /home/$USER/vzdump
sudo scp -i /home/$USER/.ssh/id_rsa "-P $rPort" $vzDumpName $rUSER@$rIP:$rPath && sudo rm $vzDumpName
echo "SCP $vzDumpName on $rIP [OK]"