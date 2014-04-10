#!/bin/bash

# package filename/directory i.e. linux-3.13.3
THIS=gcc-4.8.2

# type of archive i.e. .tar.xz
TYPE=.tar.bz2

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
if [ -d $BUILD/$THIS-build ]; then
	echo Removing build directory: $BUILD/$THIS-build
	rm -rf $BUILD/$THIS-build
fi
echo Creating build directory: $BUILD/$THIS-build &&
mkdir $BUILD/$THIS-build &&
echo Entering build directory... &&
cd $BUILD/$THIS-build &&

$BUILD/$THIS/libstdc++-v3/configure \
--host=$LFS_TGT \
--prefix=$TOOLS \
--disable-multilib \
--disable-shared \
--disable-nls \
--disable-libstdcxx-threads \
--disable-libstdcxx-pch \
--with-gxx-include-dir=$TOOLS/$LFS_TGT/include/c++/4.8.2 &&

make &&
make install

# End of Script

echo Leaving build directory... &&
cd $BUILD &&

echo Removing build directory &&
rm -rf $BUILD/$THIS-build &&

echo Removing source directory... &&
rm -rf $BUILD/$THIS &&

echo Build done: $THIS
