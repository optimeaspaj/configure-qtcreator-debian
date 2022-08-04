# configure-qtcreator for Debian cross toolchains

This repository contains utilities to quickly setup a toolchain for Debian cross compiliation,
aswell as the automatic configuration of a QtCreator Kit that allows working with the
newly installed toolchain.

Currently the supported target platforms are:

* Debian Bullseye armhf

## Requirements 

Requirements for the host system are:
* Up-to-date Bullseye installation
* Root capabilites
* Working QtCreator installation (atleast version 6.0)

Install the following dependencies on your hostsystem:

    apt install -y debootstrap qemu binfmt-support qemu-user-static \

## Building the sysroot and installing the cross toolchain

To build a sysroot containing armhf headers, libraries and more:

    cd configure-qtcreator-debian-sysroot
    mkdir ~/sysroots
    sudo ./build-sysroot.sh ~/sysroots/bullseye-armhf

Then install the debian cross toolchain on your host system:

    apt install -y g++-arm-linux-gnueabihf gdb-multiarch

## Adding the kit to your QtCreator installation

TBD in the future....