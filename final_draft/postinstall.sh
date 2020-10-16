#!/bin/bash

fdkey="KEY"

# remove FLEXnet items
/bin/rm -f /Library/Preferences/FLEXnet\ Publisher/FLEXnet/fnldrft_009b4d00_event.log
/bin/rm -f /Library/Preferences/FLEXnet\ Publisher/FLEXnet/fnldrft_009b4d00_tsf.data
/bin/rm -f /Library/Preferences/FLEXnet\ Publisher/FLEXnet/fnldrft_009b4d00_tsf.data_backup.001

# apply key to all users
for i in $(/usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 > 500 {print $2}'); do
	user_name=$(/usr/bin/id $i | /usr/bin/awk '{print $1}' | /usr/bin/sed 's/(/ /g' | /usr/bin/sed 's/)/ /g' | /usr/bin/awk '{print $2}')
	user_home=$(/usr/bin/dscl . -read /Users/$user_name NFSHomeDirectory | /usr/bin/awk '{print $2}')
	prefs="Library/Preferences/com.finaldraft.finaldraft"
	# set preferences v11
	if [[ -d /Applications/Final\ Draft\ 11.app ]]; then
		if [[ -e ${user_home}/${prefs}.v11.plist ]]; then
			/bin/mv -f ${user_home}/${prefs}.v11.plist /tmp/
		fi
		/usr/bin/defaults write ${user_home}/${prefs}.v11.plist IT-Install $fdkey
		/usr/bin/defaults write ${user_home}/${prefs}.v11.plist IT-Install-NoPrompt -bool true
		/usr/bin/defaults write ${user_home}/${prefs}.v11.plist SUEnableAutomaticChecks -bool false
		/usr/bin/defaults write ${user_home}/${prefs}.v11.plist ShowRegister -bool false
		/usr/bin/defaults write ${user_home}/${prefs}.v11.plist DoNotShowWhatsNewDialog -bool true
		/usr/sbin/chown $user_name ${user_home}/${prefs}.v11.plist
		/bin/chmod 600 ${user_home}/${prefs}.v11.plist
	fi
done

/usr/bin/killall cfprefsd

exit 0
