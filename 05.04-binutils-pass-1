#!/bin/bash

# package filename/directory i.e. linux-3.13.3
THIS=binutils-2.24

# type of archive i.e. .tar.xz
TYPE=.tar.bz2

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

# Script
mkdir -v $BUILD/$THIS-build &&
cd $BUILD/$THIS-build &&

$BUILD/$THIS/configure \
--prefix=$TOOLS \
--with-sysroot=$LFS \
--with-lib-path=$TOOLS/lib \
--target=$LFS_TGT \
--disable-nls \
--disable-werror &&

make

case $(uname -m) in
x86_64) mkdir -v $TOOLS/lib && ln -sv lib $TOOLS/lib64 ;;
esac

make install &&

cd $BUILD
rm -rf $THIS $THIS-build
