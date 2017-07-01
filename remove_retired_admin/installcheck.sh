#!/bin/bash
OLD_ACCT="oldadmin"
OLD_ACCT_CHK=$(/usr/bin/dscl . -list /Users | grep -w 'oldadmin')
NEW_ACCT="newadmin"
NEW_ACCT_CHK=$(/usr/bin/dscl . -list /Users | grep -w 'newadmin')

if [[ $NEW_ACCT_CHK == $NEW_ACCT ]]; then
	if [[ $OLD_ACCT_CHK == $OLD_ACCT ]]; then
		exit 0
	else
		exit 1
	fi
else
	exit 1
fi