# Author:	Jesus Elias
# Description:	Makefile for The Luggage

include /usr/local/share/luggage/luggage.make

TITLE=mount_share
REVERSE_DOMAIN=com.laurenceschool
PACKAGE_VERSION=1.0
PAYLOAD=\
		pack-mount_share.sh

l_outset_login_every: l_root
	@sudo mkdir -p ${WORK_D}/usr/local/outset/login-every

pack-mount_share.sh: l_outset_login_every
	@sudo ${CP} mount_share.sh ${WORK_D}/usr/local/outset/login-every

modify_packageroot:
	@sudo chown root:wheel ${WORK_D}/usr/local/outset/login-every/mount_share.sh
	@sudo chmod 755 ${WORK_D}/usr/local/outset/login-every/mount_share.sh