#!/bin/bash

# package filename/directory i.e. linux-3.13.3
THIS=tcl8.6.1

# type of archive i.e. .tar.xz
TYPE=-src.tar.gz

LFS_HOST_DIR=/lfs/7.5-systemd
PACKAGES=$LFS_HOST_DIR/packages
PATCHES=$LFS_HOST_DIR/patches
BUILD=$LFS_HOST_DIR/build


echo Entering build directory: $BUILD &&
cd  $BUILD 

if [ -d $BUILD/$THIS ]; then
	echo Removing source directory: $BUILD/THIS
	rm -rf $BUILD/$THIS
fi

echo Extracting package: $PACKAGES/${THIS}${TYPE} &&
tar xf $PACKAGES/${THIS}${TYPE} &&

echo Entering source directory: $BUILD/${THIS} &&
cd $BUILD/$THIS &&

echo Executing build script... &&

# Script
cd unix &&
./configure --prefix=$TOOLS &&
make &&
make install &&
chmod -v u+w /tools/lib/libtcl8.6.so &&
make install-private-headers &&
ln -sv tclsh8.6 /tools/bin/tclsh &&

if [ -d $BUILD/$THIS-build ]; then
	echo Removing build directory: $BUILD/$THIS-build
	rm -rf $BUILD/$THIS-build
fi
#echo Creating build directory: $BUILD/$THIS-build &&
#mkdir $BUILD/$THIS-build &&
#echo Entering build directory... &&
#cd $BUILD/$THIS-build &&


# End of Script

echo Leaving build directory...
cd $BUILD

if [ -d $BUILD/$THIS-build ]; then
	echo Removing build directory: $BUILD/$THIS-build
	rm -rf $BUILD/$THIS-build
fi

echo Removing source directory...
rm -rf $BUILD/$THIS

echo Build done: $THIS
