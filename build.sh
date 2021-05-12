#!/bin/sh
#
# Build script by McMCC, 2019-2021
#

build_clean() {
	ARCH=mips CROSS_COMPILE=`pwd`/toolchains/bin/mipsel-ndms-linux-musl- make distclean
}

dist_clean() {
	build_clean
	rm -rf ./toolchains
	rm -f *.tar.gz
}

chk_toolchains() {
	if [ ! -x ./toolchains/bin/mipsel-ndms-linux-musl-gcc ]; then
		mkdir -p toolchains
		cd ./toolchains
		wget https://github.com/ndmsystems/crosstool-ng/releases/download/crosstool-ng-1.24.0-rc2-ndm-21/toolchain_1.24.0-rc2-ndm-21_mipsel-ndms-linux-musl_20042021_1725.tar.bz2
		tar xvpjf toolchain_1.24.0-rc2-ndm-21_mipsel-ndms-linux-musl_20042021_1725.tar.bz2
		rm -f toolchain_1.24.0-rc2-ndm-21_mipsel-ndms-linux-musl_20042021_1725.tar.bz2
		cd ..
	fi
}

set_config() {
	if [ ! -f .config ]; then
		cp -f $XCPU.config .config
	fi
}

build_dvb_drivers() {
	ARCH=mips CROSS_COMPILE=`pwd`/toolchains/bin/mipsel-ndms-linux-musl- make modules
}

preinstall_dvb_drivers() {
	INSTALL_MOD_PATH="`pwd`/modules-$XCPU" ARCH=mips CROSS_COMPILE=`pwd`/toolchains/bin/mipsel-ndms-linux-musl- make modules_install
	mkdir -p ./modules-$XCPU/4.9`cat localversion-ndm`/kernel-4.9
	mv -f ./modules-$XCPU/lib/modules/4.9`cat localversion-ndm`/kernel/drivers ./modules-$XCPU/4.9`cat localversion-ndm`/kernel-4.9/drivers
	rm -rf ./modules-$XCPU/4.9`cat localversion-ndm`/kernel-4.9/drivers/hid
	rm -f ./modules-$XCPU/4.9`cat localversion-ndm`/kernel-4.9/drivers/input/evdev.ko
	mv -f ./modules-$XCPU/4.9`cat localversion-ndm`/kernel-4.9/drivers/media/compat.ko ./modules-$XCPU/4.9`cat localversion-ndm`/kernel-4.9/
	ln -sf /lib/modules/4.9`cat localversion-ndm` ./modules-$XCPU/4.9`cat localversion-ndm`/kernel
	rm -rf ./modules-$XCPU/lib
}

gzip_archive() {
	cd ./modules-$XCPU
	tar cvpzf ../${XCPU}_4.9`cat ../localversion-ndm`_`date +"%d%m%Y%H"`.tar.gz 4.9`cat ../localversion-ndm`
	cd ..
	rm -rf ./modules-$XCPU
}

build_main() {
	echo "Build DVB drivers for $XCPU."
	sleep 2
	chk_toolchains
	set_config
	build_dvb_drivers
	preinstall_dvb_drivers
	gzip_archive
}

case "$1" in
	mt7621)
		XCPU=mt7621
		build_main
		;;
	mt7628)
		XCPU=mt7628
		build_main
		;;
	clean)
		build_clean
		;;
	distclean)
		dist_clean
		;;
	*)
		echo "Usage $0 <mt7621|mt7628|clean|distclean>"
		;;
esac
