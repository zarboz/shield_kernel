#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

PROPER=`echo $1 | sed 's/\([a-z]\)\([a-zA-Z0-9]*\)/\u\1\2/g'`

if cat /etc/issue | grep Ubuntu; then
    HANDLE=twistedumbrella
    KERNELSPEC=~/android/roth-kernel-starkissed
    ANDROIDREPO=~/Dropbox/TwistedServer/Playground
    TOOLCHAIN_PREFIX=~/android/android-toolchain-eabi/bin/arm-eabi-

    cd $KERNELSPEC/mkboot

    gcc -o mkbootfs mkbootfs.c

    gcc -c rsa.c
    gcc -c sha.c
    gcc -c mkbootimg.c
    gcc rsa.o sha.o mkbootimg.o -o mkbootimg
    rm *.o

    cp -R mkbootfs $MKBOOTIMG/linux
    cp -R mkbootimg $MKBOOTIMG/linux

else
    HANDLE=TwistedZero
    KERNELSPEC=/Volumes/android/roth-kernel-starkissed
    ANDROIDREPO=/Users/TwistedZero/Public/Dropbox/TwistedServer/Playground
    TOOLCHAIN_PREFIX=/Volumes/android/android-toolchain-eabi/bin/arm-eabi-
    PUNCHCARD=`date "+%m-%d-%Y_%H.%M"`
fi

MKBOOTIMG=$KERNELSPEC/buildImg
KERNELREPO=$ANDROIDREPO/kernels
GOOSERVER=loungekatt@upload.goo.im:public_html

CPU_JOB_NUM=8

cd $KERNELSPEC

    zipfile=$HANDLE"_StarKissed-JB43-Roth.zip"
    KENRELZIP="StarKissed-JB43_$PUNCHCARD-Roth.zip"
    KERNELDIR="shieldSKU"
    cp -R config/$1_config .config

make clean -j$CPU_JOB_NUM

make -j$CPU_JOB_NUM ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX

if [ -e arch/arm/boot/zImage ]; then

        cp -R .config arch/arm/configs/starkissed_defconfig

    if [ `find . -name "*.ko" | grep -c ko` > 0 ]; then

        find . -name "*.ko" | xargs ${TOOLCHAIN_PREFIX}strip --strip-unneeded


        if [ ! -e $KERNELSPEC/$KERNELDIR/system ]; then
        mkdir $KERNELSPEC/$KERNELDIR/system
        fi
        if [ ! -e $KERNELSPEC/$KERNELDIR/system/lib ]; then
        mkdir $KERNELSPEC/$KERNELDIR/system/lib
        fi
        if [ ! -e $KERNELSPEC/$KERNELDIR/system/lib/modules ]; then
        mkdir $KERNELSPEC/$KERNELDIR/system/lib/modules
        else
        rm -r $KERNELSPEC/$KERNELDIR/system/lib/modules
        mkdir $KERNELSPEC/$KERNELDIR/system/lib/modules
        fi

        for j in $(find . -name "*.ko"); do
        cp -R "${j}" $KERNELSPEC/$KERNELDIR/system/lib/modules
        done

    else

        if [ -e $KERNELSPEC/$KERNELDIR/system/lib ]; then
        rm -r $KERNELSPEC/$KERNELDIR/system/lib
        fi

    fi

    cp -R arch/arm/boot/zImage $MKBOOTIMG

    cd $MKBOOTIMG
    ./img.sh

    echo "building kernel package"
    cp -R boot.img ../$KERNELDIR
    cd ../$KERNELDIR
    rm *.zip
    zip -r $zipfile *
    cd ../
    cp -R $KERNELSPEC/$KERNELDIR/$zipfile $KERNELREPO/$zipfile

    if [ -e $KERNELREPO/$zipfile ]; then
        cp -R $KERNELREPO/$zipfile $KERNELREPO/gooserver/$KENRELZIP
        scp -P 2222 $KERNELREPO/gooserver/$KENRELZIP  $GOOSERVER/starkissed
        rm -r $KERNELREPO/gooserver/*
    fi

fi
