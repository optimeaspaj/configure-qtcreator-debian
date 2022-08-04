#!/bin/bash

HOST_ARCH=amd64
TARGET_ARCH=armhf
DEB_RELEASE=bullseye
CHROOT_PATH="$(realpath $1)/${DEB_RELEASE}-${TARGET_ARCH}-chroot"
SYSROOT_PATH="$(realpath $1)/${DEB_RELEASE}-${TARGET_ARCH}-sysroot"

set -xe

install_packages(){
	awk '/^[^#]/{ print;}' $2  > ${1}/etc/${2}
	chroot ${1} /bin/bash -c "apt update && xargs apt install -y < /etc/${2} --"
}


chroot_init(){
	local ARCH=$1
	local DEST=$2

	debootstrap --foreign --arch ${ARCH} --variant minbase ${DEB_RELEASE} ${DEST}
	
	chroot ${DEST} /bin/bash -c "useradd -u 0 root"
}


target_sysroot_init(){
	local sysroot=$1
	local chroot=$2

	mkdir $1/{usr,opt} -p
	test -d ${sysroot}/usr/bin || mkdir ${sysroot}/usr/bin
	cp -r ${chroot}/lib ${sysroot} 
	cp -r ${chroot}/usr/include ${sysroot}/usr
	cp -r ${chroot}/usr/lib ${sysroot}/usr
	cp ${chroot}/usr/bin/*qmake ${sysroot}/usr/bin

	wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
	chmod +x sysroot-relativelinks.py

	sed -i '1c#!/usr/bin/env python3' sysroot-relativelinks.py	

	./sysroot-relativelinks.py ${sysroot}
	rm sysroot-relativelinks.py
}

install_toolchain_file(){
	local file=$1
	local sysroot=$2

	awk "{ gsub(/<<sysroot>>/,"\""${SYSROOT_PATH}"\""); print; }" ${file} > ${sysroot}/toolchain.cmake
}

main(){
	if [ ! -f ${CHROOT_PATH}/etc/os-release ]; then
		chroot_init ${TARGET_ARCH} ${CHROOT_PATH}
	fi

	install_packages ${CHROOT_PATH} target.packages

	target_sysroot_init $SYSROOT_PATH $CHROOT_PATH

	install_toolchain_file toolchain.cmake ${SYSROOT_PATH}

	echo "Succesfully build chroot at ${CHROOT_PATH}"
}

main
