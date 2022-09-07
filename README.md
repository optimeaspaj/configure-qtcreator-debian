# configure-qtcreator for Debian cross toolchains

**DISCLAMER: This repository is still work in progress**

This repository contains utilities to setup a toolchain for Debian cross compiliation,
aswell as the automatic configuration of a QtCreator Kit that allows working with the
newly installed toolchain.

Currently the supported target platforms are:

* Debian Bullseye armhf

## Requirements 

Requirements for the host system are:
* Up-to-date Bullseye installation
* Root capabilites
* A QtCreator installation

Install the following dependencies on your hostsystem:

    apt install -y debootstrap qemu binfmt-support qemu-user-static

## Building the sysroot and installing the cross toolchain

To build a sysroot containing armhf headers, libraries etc.:

    cd configure-qtcreator-debian-sysroot
    mkdir ~/sysroots
    sudo ./build-sysroot.sh ~/sysroots/bullseye-armhf

Then install the debian cross toolchain on your host system:

    apt install -y g++-arm-linux-gnueabihf gdb-multiarch

You are now able to crosscompile applications for the Debian armhf platforms.

## Example: Manually compiling, depolying and debugging a Qt C++ application via the CLI

To demonstrate the workflow to compile an application. This section covers
the steps to take.

We may use the example `hello-world` Qt project hosted on the optimeas github
repositories

    git clone https://github.com/optimeas/helloworld.git
    cd helloworld

Then follow the usual steps to configure, generate and build with CMake, except 
you pass the CMake-Toolchain file of your sysroot on the configure step.

    cmake -Bbuild -S. -DCMAKE_TOOLCHAIN_FILE=${HOME}/sysroots/bullseye-armhf/bullseye-armhf-sysroot/toolchain.cmake
    cmake --build build 

### Deploying the application on an armhf device via ssh

This subsection covers the depolyment to a target armhf device, via ssh

First install the application into a temporary folder:

    cmake --build build --target install DESTDIR=./tmp

Then copy the installation artifacts via ssh:

    scp -r ./tmp/ user@${TARGET_IP}:.


## Adding the kit to your QtCreator installation

TBD in the future....
