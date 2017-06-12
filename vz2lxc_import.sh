
#!/bin/bash
#===============================================================================
#
#          FILE: vz2lxc_import.sh
#
#         USAGE: ./vz2lxc_import.sh [ID]
#
#   DESCRIPTION: Small migration script vz to lxc
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Corentin (DevOps Engineer & Programmer)
#       CREATED: 12/06/2017 10:11:02
#      REVISION:  ---
#===============================================================================

if [[ $EUID -eq 0 ]]; then
   echo "This script must NOT be run as root" 1>&2
   exit 1
fi

# Taking args
ID=$1

# Vars
USER=""
dumpPath="/var/lib/vz/template/cache"
dumpName=$(cat $dumpPath/vz.log)

# Check for ID 
if [ -z $ID ] ; then
    echo 'No vz ID passed'
    exit
elif [[ ! $ID =~ ^[0-9]+$ ]]; then
    echo "$ID: expecting a number"
    exit
fi

####################
# Restoring to LXC #
####################

sudo pct restore $ID $dumpPath/$dumpName && \
    echo "pct $ID restoring [OK]"

# At this poin, you can set network configuration
# exemple : pct set 101 -net0 name=eth0,bridge=vmbr0,ip=192.168.15.144/24,gw=192.168.15.1
# I prefer doing it manually

sudo pct start $ID
sudo pct enter $ID