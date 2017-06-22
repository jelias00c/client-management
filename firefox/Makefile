# Author:	Jesus Elias
# Description:	Makefile for The Luggage
#		This package will copy the JS and 
#		CFG files to the Firefox app directory

include /usr/local/share/luggage/luggage.make

TITLE=firefox_config
REVERSE_DOMAIN=com.laurenceschool
PACKAGE_VERSION=1.0
PAYLOAD=\
		pack-autoconfig.js \
		pack-firefox.cfg

modify_packageroot:
	@sudo chown -R root:admin ${WORK_D}/Applications/Firefox.app
	@sudo chmod -R 755 ${WORK_D}/Applications/Firefox.app

l_Firefox_Contents: l_root
	@sudo mkdir -p ${WORK_D}/Applications/Firefox.app/Contents/Resources/defaults/pref

pack-autoconfig.js: l_Firefox_Contents
	@sudo ${CP} autoconfig.js ${WORK_D}/Applications/Firefox.app/Contents/Resources/defaults/pref
	
pack-firefox.cfg: l_Firefox_Contents
	@sudo ${CP} firefox.cfg ${WORK_D}/Applications/Firefox.app/Contents/Resources
