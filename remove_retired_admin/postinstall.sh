#!/bin/bash
OLD_ACCT="oldadmin"
OLD_ACCT_CHK=$(/usr/bin/dscl . -list /Users | grep -w 'oldadmin')

# remove older admin account
if [[ $OLD_ACCT_CHK == $OLD_ACCT ]]; then
	/usr/bin/dscl . -delete /Users/$OLD_ACCT
fi

# move older admin home
if [[ -d /Users/$OLD_ACCT ]]; then
	mv /Users/$OLD_ACCT /var/$OLD_ACCT
fi

# set permissions
if [[ -d /var/$OLD_ACCT ]]; then
	chown -R newadmin:admin /var/$OLD_ACCT
	chmod -R 740 /var/$OLD_ACCT
fi

# remove all ARD admin access
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off
# add new admin account
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users newadmin -allowAccessFor -specifiedUsers
# add privileges
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users newadmin -privs -DeleteFiles -ControlObserve -TextMessages -OpenQuitApps -GenerateReports -RestartShutDown -SendFiles -ChangeSettings -restart -agent -menu