#!/bin/bash
# recalls the license and removes the software

LICENSE_KEY=ENTER_KEY
SMART_NB=/Applications/SMART\ Technologies/Notebook.app

if [[ -e ${SMART_NB} ]]; then
  echo "App installed. Attempting to recall SMART license..."
  /Library/Application\ Support/SMART\ Technologies/activationwizard.app/Contents/MacOS/activationwizard --puid education_bundle --m=4 --v=3 --return --pk $LICENSE_KEY
  echo "Attempting to remove SMART Tools..."
  /Applications/SMART\ Technologies/SMART\ Uninstaller.app/Contents/Resources/uninstall --all
fi

exit 0
