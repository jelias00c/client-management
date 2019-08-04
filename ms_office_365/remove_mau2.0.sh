#!/bin/bash

# unload and remove launch agent
if [[ -e /Library/LaunchAgents/com.microsoft.update.agent.plist ]]; then
	userid=$(/usr/bin/stat -f '%u' /dev/console)
	if [[ ! "$userid" == "0" ]]; then
		/bin/launchctl asuser ${userid} /bin/launchctl unload /Library/LaunchAgents/com.microsoft.update.agent.plist
	fi
	/bin/rm -f /Library/LaunchAgents/com.microsoft.update.agent.plist
fi

# unload and remove launch daemons
if [[ -e /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist ]]; then
	/bin/launchctl unload /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist
	/bin/rm -f /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist
fi
if [[ -e /Library/LaunchDaemons/com.microsoft.teams.TeamsUpdaterDaemon.plist ]]; then
	/bin/launchctl unload /Library/LaunchDaemons/com.microsoft.teams.TeamsUpdaterDaemon.plist
	/bin/rm -f /Library/LaunchDaemons/com.microsoft.teams.TeamsUpdaterDaemon.plist
fi

# remove user home items
for i in $(/usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 > 500 {print $2}'); do
	usern=$(/usr/bin/id $i | /usr/bin/awk '{print $1}' | /usr/bin/sed 's/(/ /g' | /usr/bin/sed 's/)/ /g' | /usr/bin/awk '{print $2}')
	userh=$(/usr/bin/dscl . -read /Users/$usern NFSHomeDirectory | /usr/bin/awk '{print $2}')
	if [[ -d $userh/Library/Application\ Support/Microsoft\ AU\ Daemon ]]; then
		/bin/rm -rf $userh/Library/Application\ Support/Microsoft\ AU\ Daemon
	fi
	if [[ -d $userh/Library/Application\ Support/Microsoft\ AutoUpdate ]]; then
		/bin/rm -rf $userh/Library/Application\ Support/Microsoft\ AutoUpdate
	fi
	if [[ -d $userh/Library/Caches/Microsoft/uls/com.microsoft.autoupdate.fba ]]; then
		/bin/rm -rf $userh/Library/Caches/Microsoft/uls/com.microsoft.autoupdate.fba
	fi
	if [[ -d $userh/Library/Caches/Microsoft/uls/com.microsoft.autoupdate2 ]]; then
		/bin/rm -rf $userh/Library/Caches/Microsoft/uls/com.microsoft.autoupdate2
	fi
	if [[ -e $userh/Library/Preferences/com.microsoft.autoupdate.fba.plist ]]; then
		/bin/rm -f $userh/Library/Preferences/com.microsoft.autoupdate.fba.plist
	fi
	if [[ -e $userh/Library/Preferences/com.microsoft.autoupdate2.plist ]]; then
		/bin/rm -f $userh/Library/Preferences/com.microsoft.autoupdate2.plist
	fi
done

# remove mau2 items
if [[ -e /Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper ]]; then
	/bin/rm -f /Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper
fi
if [[ -d /Library/Application\ Support/Microsoft/MAU2.0 ]]; then
	/bin/rm -rf /Library/Application\ Support/Microsoft/MAU2.0
fi
if [[ -d /Library/Application\ Support/Microsoft/TeamsUpdaterDaemon ]]; then
	/bin/rm -rf /Library/Application\ Support/Microsoft/TeamsUpdaterDaemon
fi

exit 0
