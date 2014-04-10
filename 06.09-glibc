#!/bin/bash

# package filename/directory i.e. linux-3.13.3
THIS=man-pages-3.59

# type of archive i.e. .tar.xz
TYPE=.tar.xz

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

# First fix a minor problem when installing the tzselect script:
sed -i 's/\\$$(pwd)/`pwd`/' timezone/Makefile

# Some of the Glibc programs use non-FHS compilant /var/db directory to store their runtime data.
# Apply the following patch to make such programs store their runtime data in the FHS-compliant
# locations:
patch -Np1 -i ../glibc-2.19-fhs-1.patch

# The Glibc build system is self-contained and will install perfectly, even though the compiler specs file and linker are
# still pointing at /tools. The specs and linker cannot be adjusted before the Glibc install because the Glibc autoconf
# tests would give false results and defeat the goal of achieving a clean build.

# The Glibc documentation recommends building Glibc outside of the source directory in a dedicated build directory:
if [ -d $BUILD/$THIS-build ]; then
	echo Removing build directory: $BUILD/$THIS-build
	rm -rf $BUILD/$THIS-build
fi
echo Creating build directory: $BUILD/$THIS-build &&
mkdir $BUILD/$THIS-build &&
echo Entering build directory... &&
cd $BUILD/$THIS-build &&

# Prepare Glibc for compilation:
$BUILD/$THIS/configure \
	--prefix=/usr \
	--disable-profile \
	--enable-kernel=2.6.32 \
	--enable-obsolete-rpc

make &&

# Generally a few tests do not pass, but you can generally ignore any of the test failures listed below. Now test the build
# results:
make -k check 2>&1 | tee glibc-check-log
grep Error glibc-check-log

# Though it is a harmless message, the install stage of Glibc will complain about the absence of /etc/ld.so.conf.
# Prevent this warning with:
touch /etc/ld.so.conf

#Install the package:
make install

# Install the configuration file and runtime directory for nscd:
cp -v ../glibc-2.19/nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

# Install the Systemd support files for nscd:
install -v -Dm644 ../glibc-2.19/nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../glibc-2.19/nscd/nscd.service /lib/systemd/system/nscd.service

# The locales that can make the system respond in a different language were not installed by the above command. None
# of the locales are required, but if some of them are missing, test suites of the future packages would skip important
# testcases.

# Individual locales can be installed using the localedef program. E.g., the first localedef command below combines
# the /usr/share/i18n/locales/cs_CZ charset-independent locale definition with the /usr/share/i18n/
# charmaps/UTF-8.gz charmap definition and appends the result to the /usr/lib/locale/localearchive
# file. The following instructions will install the minimum set of locales necessary for the optimal coverage
# of tests:
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

# Alternatively, install all locales listed in the glibc-2.19/localedata/SUPPORTED file (it includes every locale
# listed above and many more) at once with the following time-consuming command:
#make localedata/install-locales

# Then use the localedef command to create and install locales not listed in the glibc-2.19/localedata/
# SUPPORTED file in the unlikely case you need them.


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
