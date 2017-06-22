#!/bin/sh
# login script to hide avast notifications and menu item from user

echo "Seting Avast Menu Bar Options..."
/usr/bin/touch ~/Library/Preferences/com.avast.helper.plist
/usr/bin/defaults write ~/Library/Preferences/com.avast.helper.plist AlertPopupDuration -int 0
/usr/bin/defaults write ~/Library/Preferences/com.avast.helper.plist InfoPopupDuration -int 0
/usr/bin/defaults write ~/Library/Preferences/com.avast.helper.plist ShowMenubarIcon -int 0
/usr/bin/defaults write ~/Library/Preferences/com.avast.helper.plist UpdatePopupDuration -int 0
/usr/bin/defaults write ~/Library/Preferences/com.avast.helper.plist WarningPopupDuration -int 0