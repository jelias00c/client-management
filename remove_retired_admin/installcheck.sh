#!/bin/bash

old_account="administrator"
new_account="newadmin"

/usr/bin/dscl . -read /Users/$new_account UniqueID &> /dev/null
if [[ $? -eq '0' ]]; then
	/usr/bin/dscl . -read /Users/$old_account UniqueID &> /dev/null
	if [[ $? -eq '0' ]]; then
		exit 0
	else
		exit 1
	fi
else
	exit 1
fi