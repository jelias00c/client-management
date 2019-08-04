#!/bin/bash

for i in $(/usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 > 500 {print $2}'); do
	user_name=$(/usr/bin/id $i | /usr/bin/awk '{print $1}' | /usr/bin/sed 's/(/ /g' | /usr/bin/sed 's/)/ /g' | /usr/bin/awk '{print $2}')
	user_home=$(/usr/bin/dscl . -read /Users/$user_name NFSHomeDirectory | /usr/bin/awk '{print $2}')
	# remove license file
	/bin/rm -f "$user_home/Library/Group Containers/UBF8T346G9.Office/com.microsoft.Office365.plist"
	/bin/rm -f "$user_home/Library/Group Containers/UBF8T346G9.Office/com.microsoft.e0E2OUQxNUY1LTAxOUQtNDQwNS04QkJELTAxQTI5M0JBOTk4O.plist"
	/bin/rm -f "$user_home/Library/Group Containers/UBF8T346G9.Office/e0E2OUQxNUY1LTAxOUQtNDQwNS04QkJELTAxQTI5M0JBOTk4O"
	/bin/rm -f "$user_home/Library/Group Containers/UBF8T346G9.Office/com.microsoft.Office365V2.plist"
	/bin/rm -f "$user_home/Library/Group Containers/UBF8T346G9.Office/com.microsoft.O4kTOBJ0M5ITQxATLEJkQ40SNwQDNtQUOxATL1YUNxQUO2E0e.plist"
	/bin/rm -f "$user_home/Library/Group Containers/UBF8T346G9.Office/O4kTOBJ0M5ITQxATLEJkQ40SNwQDNtQUOxATL1YUNxQUO2E0e"
	
	# remove keychain item
	/usr/bin/sudo -u $user_name /usr/bin/security delete-internet-password -s 'msoCredentialSchemeADAL'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-internet-password -s 'msoCredentialSchemeLiveId'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'Microsoft Office Identities Settings 2'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'Microsoft Office Identities Settings 3'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'Microsoft Office Identities Cache 2'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'Microsoft Office Identities Cache 3'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'Microsoft Office Ticket Cache'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'com.microsoft.adalcache'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'MicrosoftOfficeRMSCredential'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -l 'MSProtection.framework.service'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -g 'MSOpenTech.ADAL.1'
	/usr/bin/sudo -u $user_name /usr/bin/security delete-generic-password -g 'MSOpenTech.ADAL.1'
	
	# reset activation email
	#/usr/bin/defaults delete $user_home/Library/Preferences/com.microsoft.office OfficeActivationEmailAddress
	
	# set first launch
	/usr/bin/defaults write $user_home/Library/Preferences/com.microsoft.Word kSubUIAppCompletedFirstRunSetup1507 -bool true
	/usr/bin/defaults write $user_home/Library/Preferences/com.microsoft.Excel kSubUIAppCompletedFirstRunSetup1507 -bool true
	/usr/bin/defaults write $user_home/Library/Preferences/com.microsoft.Powerpoint kSubUIAppCompletedFirstRunSetup1507 -bool true
	/usr/bin/defaults write $user_home/Library/Preferences/com.microsoft.Outlook kSubUIAppCompletedFirstRunSetup1507 -bool true
	/usr/bin/defaults write $user_home/Library/Preferences/com.microsoft.Outlook FirstRunExperienceCompletedO15 -bool true
	/usr/sbin/chown $user_name $user_home/Library/Preferences/com.microsoft.*
done

/usr/bin/killall cfprefsd

exit 0
