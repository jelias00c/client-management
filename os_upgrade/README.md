## Catalina Upgrade Self Service

This script is meant to be used from Jamf Self Service. It will perform the following actions:

  * System compatibility check
  * Use JamfHelper to display a full screen message
  * Download and assemble Install macOS Catalina app
  * Start OS install
  
It will stop the process if any of the installer components fail to download.

The compatibility check script is edited from the original version here:
[check-10.15-catalina-compatibility.py](https://github.com/hjuutilainen/adminscripts/blob/master/check-10.15-catalina-compatibility.py)
