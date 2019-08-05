#!/bin/bash

old_account="administrator"
new_account="newadmin"
ard_group_name="com.apple.local.ard_admin"
ard_kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"

# remove older admin account
/usr/bin/dscl . -delete /Users/$old_account
if [[ -d /Users/$old_account ]]; then
	/bin/mv -f /Users/$old_account /var/$old_account
	/usr/sbin/chown -R $new_account:admin /var/$old_account
fi

# update apple remote desktop access
/usr/sbin/dseditgroup -o edit -n /Local/Default -a $new_account -t user "$ard_group_name"
/usr/sbin/dseditgroup -o edit -n /Local/Default -d $old_account -t user "$ard_group_name"
$ard_kickstart -restart -quiet

exit 0
