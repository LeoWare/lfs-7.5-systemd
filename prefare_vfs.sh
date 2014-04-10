#!/bin/bash
# this file is to be run as root on the host system

LFS=.
for dir in "dev proc sys run"
do
	if [ ! -d "$LFS/$dir" ]; then
		mkdir -pv $LFS/$dir
	fi
done

for dev in "console null"
do
	echo $LFS/dev/$dev
	if [ ! -c "$LFS/dev/$dev" ]; then
		if [ "$dev" = "console" ]; then
			mknod -mv 600 $LFS/dev/console c 5 1
		fi
		if [ "$dev" = "null" ]; then
			mknod -mv 666 $LFS/dev/null c 1 3
		fi
	fi
done

mount -v --bind /dev $LFS/dev
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi