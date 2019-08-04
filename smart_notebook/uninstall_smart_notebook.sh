#!/bin/bash
# recalls the license and removes the software

license_key="KEY"
smart_notebook="/Applications/SMART Technologies/Notebook.app"
activationwizard="/Library/Application\ Support/SMART\ Technologies/activationwizard.app/Contents/MacOS/activationwizard"
uninstaller="/Applications/SMART\ Technologies/SMART\ Uninstaller.app/Contents/Resources/uninstall"

if [[ -e "$smart_notebook" ]]; then
	/bin/echo "Uninstalling SMART Notebook"
	$activationwizard --puid education_bundle --m=4 --v=3 --return --pk $license_key
	$uninstaller --all
fi

exit 0
