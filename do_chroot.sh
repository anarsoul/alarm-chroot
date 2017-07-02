#!/bin/bash

set -e

cleanup() {
	if [ -e "$DEST/proc/cmdline" ]; then
		umount "$DEST/proc"
	fi
	if [ -d "$DEST/sys/kernel" ]; then
		umount "$DEST/sys"
	fi
	umount "$DEST/tmp" || true
}
trap cleanup EXIT

DEST=dest_dir

mount -o bind /tmp "$DEST/tmp"
chroot "$DEST" mount -t proc proc /proc
chroot "$DEST" mount -t sysfs sys /sys
#chroot "$DEST" mv /etc/resolv.conf /etc/resolv.conf.dist
cp /etc/resolv.conf $DEST/etc/resolv.conf
chroot "$DEST" $@
#chroot "$DEST" mv /etc/resolv.conf.dist /etc/resolv.conf
chroot "$DEST" umount /sys
chroot "$DEST" umount /proc
umount "$DEST/tmp"
