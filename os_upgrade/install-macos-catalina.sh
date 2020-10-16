#!/bin/bash

tempdir="/tmp/E43E34C6-02BB-11EB-ADC1-0242AC120002"
downloadurl="http://swcdn.apple.com/content/downloads/20/55/001-51042-A_2EJTJOSUC2/rsvf13iphg5lvcqcysqcarv8cvddq8igek"
wbatools="/usr/local/wba/os_upgrade"
jamfico="$wbatools/InstallAssistant.icns"
jamfhead="Please wait while we prepare your Mac for macOS Catalina."
jamfhead2="macOS Catalina Upgrade"
jamfdesc="This process may take approximately 5-10 minutes.
Your computer will reboot and begin the upgrade soon."
jamfdesc2="Your computer is not compatible with macOS Catalina."
jamfdesc3="Failed to download installer files.
Please check your internet connection and try again."

# reset temp folder
if [[ -d $tempdir ]]; then
	/bin/rm -rf $tempdir
	/bin/mkdir $tempdir
else
	/bin/mkdir $tempdir
fi

# check catalina support
/usr/bin/env python $wbatools/catalina-check.py
catasupport=$(/usr/bin/defaults read $tempdir/catalina.plist catalina_supported)
if [[ $catasupport -eq '0' ]]; then
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -title "" -icon "$jamfico" -heading "$jamfhead2" -description "$jamfdesc2" &
	exit 0
fi

# fullscreen message during download
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType fs -title "" -icon "$jamfico" -heading "$jamfhead" -description "$jamfdesc" &
jamfhelperpid=$(echo $!)

# download installer parts
$wbatools/curl -v --cacert $wbatools/cacert.pem -L -s -o $tempdir/InstallAssistantAuto.pkg $downloadurl/InstallAssistantAuto.pkg
$wbatools/curl -v --cacert $wbatools/cacert.pem -L -s -o $tempdir/AppleDiagnostics.chunklist $downloadurl/AppleDiagnostics.chunklist
$wbatools/curl -v --cacert $wbatools/cacert.pem -L -s -o $tempdir/AppleDiagnostics.dmg $downloadurl/AppleDiagnostics.dmg
$wbatools/curl -v --cacert $wbatools/cacert.pem -L -s -o $tempdir/BaseSystem.chunklist $downloadurl/BaseSystem.chunklist
$wbatools/curl -v --cacert $wbatools/cacert.pem -L -s -o $tempdir/BaseSystem.dmg $downloadurl/BaseSystem.dmg
$wbatools/curl -v --cacert $wbatools/cacert.pem -L -s -o $tempdir/InstallESD.dmg $downloadurl/InstallESDDmg.pkg

# extract Install macOS Catalina.app
#cd $tempdir
#$wbatools/pbzx $tempdir/InstallAssistantAuto.pkg | "$@" /usr/bin/cpio -i
/usr/sbin/pkgutil --expand-full $tempdir/InstallAssistantAuto.pkg $tempdir/Catalina_App
/bin/mv $tempdir/Catalina_App/Payload/Install\ macOS\ Catalina.app $tempdir/

# move all items to Applications
if [[ -d $tempdir/Install\ macOS\ Catalina.app ]]; then
	/bin/mv $tempdir/Install\ macOS\ Catalina.app /Applications/
else
	downloadfailed='1'
fi
if [[ -e $tempdir/AppleDiagnostics.chunklist ]]; then
	/bin/mv $tempdir/AppleDiagnostics.chunklist /Applications/Install\ macOS\ Catalina.app/Contents/SharedSupport/
else
	downloadfailed='1'
fi
if [[ -e $tempdir/AppleDiagnostics.dmg ]]; then
	/bin/mv $tempdir/AppleDiagnostics.dmg /Applications/Install\ macOS\ Catalina.app/Contents/SharedSupport/
else
	downloadfailed='1'
fi
if [[ -e $tempdir/BaseSystem.chunklist ]]; then
	/bin/mv $tempdir/BaseSystem.chunklist /Applications/Install\ macOS\ Catalina.app/Contents/SharedSupport/
else
	downloadfailed='1'
fi
if [[ -e $tempdir/BaseSystem.dmg ]]; then
	/bin/mv $tempdir/BaseSystem.dmg /Applications/Install\ macOS\ Catalina.app/Contents/SharedSupport/
else
	downloadfailed='1'
fi
if [[ -e $tempdir/InstallESD.dmg ]]; then
	/bin/mv $tempdir/InstallESD.dmg /Applications/Install\ macOS\ Catalina.app/Contents/SharedSupport/
else
	downloadfailed='1'
fi

# failed to download message
if [[ $downloadfailed -eq '1' ]]; then
	kill -9 $jamfhelperpid
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -title "" -icon "$jamfico" -heading "$jamfhead2" -description "$jamfdesc3" &
	exit 0
fi

# cleanup
/bin/rm -rf $wbatools
/bin/rm -rf $tempdir

# start os install
/Applications/Install\ macOS\ Catalina.app/Contents/Resources/startosinstall --agreetolicense --nointeraction --pidtosignal $jamfhelperpid &

exit 0
