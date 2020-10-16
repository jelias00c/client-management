#!/bin/bash

# get current console user
current_user=$(/usr/bin/stat -f '%u' /dev/console)

# remove jre plugin and prefpane
/bin/rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
/bin/rm -rf /Library/PreferencePanes/JavaControlPanel.prefPane

# use unique id to get username and home dir
for i in $(/usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 > 500 {print $2}'); do
	user_name=$(/usr/bin/id $i | /usr/bin/awk '{print $1}' | /usr/bin/sed 's/(/ /g' | /usr/bin/sed 's/)/ /g' | /usr/bin/awk '{print $2}')
	user_home=$(/usr/bin/dscl . -read /Users/$user_name NFSHomeDirectory | /usr/bin/awk '{print $2}')
	# remove deployment cache
	/bin/rm -rf $user_home/Library/Application\ Support/Oracle/Java
	# remove preferences
	/bin/rm -f $user_home/Library/Preferences/com.oracle.java.JavaAppletPlugin.plist
	/bin/rm -f $user_home/Library/Preferences/com.oracle.java.JavaUpdater.plist
	/bin/rm -f $user_home/Library/Preferences/com.oracle.javadeployment.plist
done

# remove launchd items
if [[ -L /Library/LaunchAgents/com.oracle.java.Java-Updater.plist ]]; then
	if [[ -n $current_user ]] && [[ $current_user -ge "500" ]]; then
		/bin/launchctl asuser ${current_user} /bin/launchctl unload -F /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Resources/com.oracle.java.Java-Updater.plist
	fi
	/bin/rm -f /Library/LaunchAgents/com.oracle.java.Java-Updater.plist
fi
if [[ -L /Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist ]]; then
	/bin/launchctl unload -F /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Resources/com.oracle.java.Helper-Tool.plist
	/bin/rm -f /Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist
fi

# remove helper tools
if [[ -e /Library/LaunchDaemons/com.oracle.java.JavaUpdateHelper.plist ]]; then
	/bin/rm -f /Library/LaunchDaemons/com.oracle.java.JavaUpdateHelper.plist
fi
if [[ -e /Library/PrivilegedHelperTools/com.oracle.java.JavaUpdateHelper ]]; then
	/bin/rm -f /Library/PrivilegedHelperTools/com.oracle.java.JavaUpdateHelper
fi
if [[ -e /Library/LaunchDaemons/com.oracle.JavaInstallHelper.plist ]]; then
	/bin/rm -f /Library/LaunchDaemons/com.oracle.JavaInstallHelper.plist
fi
if [[ -e /Library/PrivilegedHelperTools/com.oracle.JavaInstallHelper ]]; then
	/bin/rm -f /Library/PrivilegedHelperTools/com.oracle.JavaInstallHelper
fi

# remove preferences
if [[ -e /Library/Preferences/com.oracle.java.Helper-Tool.plist ]]; then
	/bin/rm -f /Library/Preferences/com.oracle.java.Helper-Tool.plist
fi
if [[ -e /Library/Preferences/com.oracle.java.Deployment.plist ]]; then
	/bin/rm -f /Library/Preferences/com.oracle.java.Deployment.plist
fi

# remove jre version plist
if [[ -d "/Library/Application Support/Oracle/Java" ]]; then
	/bin/rm -rf /Library/Application\ Support/Oracle/Java
fi

# set IFS
OLDIFS=$IFS; IFS=$'\n'

# remove jdk
for i in $(/bin/ls /Library/Java/JavaVirtualMachines/ | /usr/bin/grep -i jdk); do
	/bin/rm -rf "/Library/Java/JavaVirtualMachines/$i"
done

exit 0