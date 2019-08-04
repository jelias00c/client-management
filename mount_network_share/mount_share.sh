#!/bin/bash
# login script

mount_drive=0
shareName="Shared_Files"
serverName="File_Server"
domainName="AD_DOMAIN"
log_file="~/Library/Logs/mount_drives.log"

# function for log file time stamp
get_timestamp () {
	timestamp=$(/bin/date '+%Y-%m-%d %H:%M:%S')
}

sleep 4

# check for domain account lockout
useruid=$(/usr/bin/dscl . -read /Users/$USER UniqueID | /usr/bin/awk '{print $2}')
if [[ $useruid -gt '1000' ]]; then
	userLockout=$(/usr/bin/dscl /Active\ Directory/$domainName/All\ Domains -read /Users/$USER | /usr/bin/grep "dsAttrTypeNative:lockoutTime:" | /usr/bin/awk '{print $2}')
	if [[ $userLockout -ne '0' ]]; then
		lockoutTime=$((($userLockout/10000000)-11644473600))
		converted_date=$(/bin/date -r $lockoutTime '+%Y-%m-%d %I:%M:%S %p')
		get_timestamp; /bin/echo "$timestamp ERROR: Domain account is locked. Locked on $converted_date." >> $log_file
		exit 1
	fi
fi

# check if item already mounted
OLDIFS=$IFS; IFS=$'\n'
for i in $(/bin/ls /Volumes/); do
	if [[ $i == $shareName ]]; then
		get_timestamp; /bin/echo "$timestamp ALERT: $shareName volume already mounted." >> $log_file
		mount_drive=1
	fi
done
IFS=$OLDIFS

# check if servers are reachable
testPing=$(/sbin/ping -c 1 $serverName | /usr/bin/grep -i packets | /usr/bin/awk '{print $4}')
if [[ $testPing -ne '1' ]]; then
	get_timestamp; /bin/echo "$timestamp ALERT: $shareName server unreachable." >> $log_file
	mount_drive=1
fi

# attempt mount shares
if [[ $mount_drive -eq '0' ]]; then
	/usr/bin/osascript -e 'mount volume "smb://$serverName/$shareName"'
fi

exit 0
