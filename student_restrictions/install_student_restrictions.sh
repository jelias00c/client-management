#!/bin/sh

PROFILE_VERSION="20170202"
PROFILE_IDENTIFIER=$(/usr/bin/profiles -L -U student | grep -i "restrictions" | cut -d "." -f6)
PROFILE_PATH="/usr/local/share/profiles/student_restrictions.mobileconfig"
USERNAME=$(logname)

if [ $USERNAME = student ]; then
	if [ $PROFILE_IDENTIFIER = $PROFILE_VERSION ]; then
			echo "Restrictions profile installed."
		else
			echo "Restrictions profile not installed. Installing..."
			/usr/bin/profiles -I -F $PROFILE_PATH -U student
	fi
fi

exit 0