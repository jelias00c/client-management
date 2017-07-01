#!/bin/sh
mount_script=`/usr/bin/osascript > /dev/null << EOF
set mountShare to true

# check if share is already mounted
tell application "Finder"
	delay 1.0
	set disklist to list disks
	repeat with i from 1 to number of items in disklist
		if item i of disklist is equal to "DriveShareName" then
			set mountShare to false
		end if
	end repeat
end tell

# check if server is reachable
set pingStatus to (do shell script "ping -c 1 server.domain.pri; echo offline")
if pingStatus is equal to "offline" then
	set mountShare to false
end if

# mount share
if mountShare is true then
	ignoring application responses
		mount volume "smb://server.domain.pri/DriveShareName"
	end ignoring
end if
EOF`