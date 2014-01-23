#!/bin/sh
# Inspired by <http://guylabs.ch/2013/09/18/install-clamav-antivirus-in-ubuntu-server-and-client/>
 
NOW=`/bin/date '+%Y%m%dT%H%M%S'` # ISO 8601 format
LOGFILE="/var/log/clamav/clamav-scan.log.$NOW"
HOST=`/bin/hostname`

CLAMDSCAN="/usr/bin/clamdscan --fdpass --log=$LOGFILE --multiscan"

# emtpy the old scanlog and do a virus scan
rm -f $LOGFILE
touch $LOGFILE
echo "Scan Started" > $LOGFILE
date >> $LOGFILE
echo "============" >> $LOGFILE

if [ $# -gt 0 ] ; then
    $CLAMDSCAN $*
else
    $CLAMDSCAN /
fi

echo "============" >> $LOGFILE
echo "Scan Ended" >> $LOGFILE
date >> $LOGFILE
 
### Send the email
if grep -rl 'Infected files: 0' $LOGFILE
    then
	echo "No virus found"
    else
	cat $LOGFILE | /usr/bin/mailx -s "Virus warning for $HOST at $NOW" root
fi

rm -R $LOGFILE
