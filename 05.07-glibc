#!/bin/bash

# package filename/directory i.e. linux-3.13.3
THIS=glibc-2.19

# type of archive i.e. .tar.xz
TYPE=.tar.xz

LFS_HOST_DIR=/lfs/7.5-systemd
PACKAGES=$LFS_HOST_DIR/packages
PATCHES=$LFS_HOST_DIR/patches
BUILD=$LFS_HOST_DIR/build


echo Entering build directory: $BUILD &&
cd  $BUILD 

if [ -d $BUILD/$THIS ]; then
	echo Removing source directory: $BUILD/$THIS
	rm -rf $BUILD/$THIS
fi

echo Extracting package: $PACKAGES/${THIS}${TYPE} &&
tar xf $PACKAGES/${THIS}${TYPE} &&

echo Entering source directory: $BUILD/${THIS} &&
cd $BUILD/$THIS &&

echo Executing build script... &&

# Script
if [ ! -r /usr/include/rpc/types.h ]; then
	su -c 'mkdir -pv /usr/include/rpc'
	su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc'
fi

echo Creating build directory: $BUILD/$THIS-build &&
mkdir $BUILD/$THIS-build &&
echo Entering build directory... &&
cd $BUILD/$THIS-build &&

$BUILD/$THIS/configure \
--prefix=$TOOLS \
--host=$LFS_TGT \
--build=$($BUILD/$THIS/scripts/config.guess) \
--disable-profile \
--enable-kernel=2.6.32 \
--with-headers=$TOOLS/include \
libc_cv_forced_unwind=yes \
libc_cv_ctors_header=yes \
libc_cv_c_cleanup=yes &&

make &&
make install

echo Executing post-install test...
echo 'main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ": ${TOOLS}"

echo Cleaning up after test...
rm -v dummy.c a.out

# End of Script

echo Leaving build directory...
cd $BUILD &&

echo Removing build directory
rm -rf $BUILD/$THIS-build &&

echo Removing source directory...
rm -rf $BUILD/$THIS &&

echo Build done: $THIS
