#!/bin/bash

# package filename/directory i.e. linux-3.13.3
THIS=linux-3.13.3

# type of archive i.e. .tar.xz
TYPE=.tar.xz

LFS_HOST_DIR=/lfs/7.5-systemd
PACKAGES=$LFS_HOST_DIR/packages
PATCHES=$LFS_HOST_DIR/patches
BUILD=$LFS_HOST_DIR/build


echo Entering build directory: $BUILD &&
cd  $BUILD &&

echo Extracting package: $PACKAGES/${THIS}${TYPE} &&
tar xf $PACKAGES/${THIS}${TYPE} &&

echo Entering source directory: $BUILD/${THIS} &&
cd $BUILD/$THIS &&

echo Executing build script...

# Script
make mrproper && 

make headers_check &&
make INSTALL_HDR_PATH=dest headers_install &&
cp -rv dest/include/* $TOOLS/include &&

# End of Script

echo Leaving source directory... &&
cd $BUILD &&

echo Removing source directory... &&
rm -rf $BUILD/$THIS &&

echo Build done: $THIS
