#!/bin/bash

sbp_app=$(/bin/ls /Applications/ | /usr/bin/grep 'Toon Boom Storyboard Pro' | /usr/bin/sort -r | /usr/bin/head -n 1)
lic_dat="/usr/local/flexlm/licenses/license.dat"

# write license file
if [[ ! -e  $lic_dat ]]; then
	/bin/echo "SERVER license.server.pri 0 ANY" >> $lic_dat
	/bin/echo "VENDOR toonboom" >> $lic_dat
	/bin/echo "USE_SERVER" >> $lic_dat
fi

#  activate anchor service
"/Applications/$sbp_app/Tools.localized/LicenseWizard.app/Contents/MacOS/LicenseWizard" --console --install-anchor &> /dev/null

exit 0
