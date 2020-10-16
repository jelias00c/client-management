#!/bin/bash

# set default rv_link handler for each user
for i in $(/usr/bin/dscl . -list /Users UniqueID | /usr/bin/awk '$2 > 500 {print $2}'); do
	user_name=$(/usr/bin/id $i | /usr/bin/awk '{print $1}' | /usr/bin/sed 's/(/ /g' | /usr/bin/sed 's/)/ /g' | /usr/bin/awk '{print $2}')
	user_home=$(/usr/bin/dscl . -read /Users/$user_name NFSHomeDirectory | /usr/bin/awk '{print $2}')
	
	# check for any existing handlers
	launchserv_plist="$user_home/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
	handler_check1=$(/usr/bin/defaults read $launchserv_plist LSHandlers | /usr/bin/grep "com.tweaksoftware.RV64" | /usr/bin/awk -F "= " '{print $2}' | /usr/bin/sed 's/\"//' | /usr/bin/sed 's/\";//')
	handler_check2=$(/usr/bin/defaults read $launchserv_plist LSHandlers | /usr/bin/grep "com.tweaksoftware.RVSDI" | /usr/bin/awk -F "= " '{print $2}' | /usr/bin/sed 's/\"//' | /usr/bin/sed 's/\";//')
	handler_check3=$(/usr/bin/defaults read $launchserv_plist LSHandlers | /usr/bin/grep "com.tweaksoftware.rv" | /usr/bin/awk -F "= " '{print $2}' | /usr/bin/sed 's/\"//' | /usr/bin/sed 's/\";//')
	
	# remove rv64
	array_index='0'
	if [[ "$handler_check1" == "com.tweaksoftware.RV64" ]]; then
		/usr/libexec/PlistBuddy -c "Print LSHandlers:$array_index" $launchserv_plist | /usr/bin/grep com.tweaksoftware.RV64 1> /dev/null
		while [ $? -eq '1' ]; do
			((array_index++))
			/usr/libexec/PlistBuddy -c "Print LSHandlers:$array_index" $launchserv_plist | /usr/bin/grep com.tweaksoftware.RV64 1> /dev/null
		done
		/usr/libexec/PlistBuddy -c "Delete LSHandlers:$array_index" $launchserv_plist
	fi
	
	# remove rvsdi
	array_index='0'
	if [[ "$handler_check2" == "com.tweaksoftware.RVSDI" ]]; then
		/usr/libexec/PlistBuddy -c "Print LSHandlers:$array_index" $launchserv_plist | /usr/bin/grep com.tweaksoftware.RVSDI 1> /dev/null
		while [ $? -eq '1' ]; do
			((array_index++))
			/usr/libexec/PlistBuddy -c "Print LSHandlers:$array_index" $launchserv_plist | /usr/bin/grep com.tweaksoftware.RVSDI 1> /dev/null
		done
		/usr/libexec/PlistBuddy -c "Delete LSHandlers:$array_index" $launchserv_plist
	fi
	
	# add rv as default rvlink handler
	array_index='0'
	if [[ "$handler_check3" == "" ]]; then
		/usr/libexec/PlistBuddy -c "Print LSHandlers:$array_index" $launchserv_plist 1> /dev/null
		while [ $? -eq '0' ]; do
			((array_index++))
			/usr/libexec/PlistBuddy -c "Print LSHandlers:$array_index" $launchserv_plist 1> /dev/null
		done
		/usr/libexec/PlistBuddy -c "Add LSHandlers array" $launchserv_plist 2> /dev/null
		/usr/libexec/PlistBuddy -c "Add LSHandlers:$array_index:LSHandlerURLScheme string rvlink" $launchserv_plist
		/usr/libexec/PlistBuddy -c "Add LSHandlers:$array_index:LSHandlerPreferredVersions dict" $launchserv_plist
		/usr/libexec/PlistBuddy -c "Add LSHandlers:$array_index:LSHandlerPreferredVersions:LSHandlerRoleAll string -" $launchserv_plist
		/usr/libexec/PlistBuddy -c "Add LSHandlers:$array_index:LSHandlerRoleAll string com.tweaksoftware.rv" $launchserv_plist
	fi
	
	/usr/sbin/chown $user_name $launchserv_plist
	/bin/chmod 600 $launchserv_plist
done

exit 0
