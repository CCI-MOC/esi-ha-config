#!/bin/sh

src=/scratch/lars/images/CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2
dst=esi-base.qcow2
dst_size=20g

if ! [[ -f $src ]]; then
	echo "ERROR: missing source image $src" >&2
	exit 1
fi

if ! [[ -f $dst ]]; then
	echo "Creating boot image..."
	qemu-img convert -f qcow2 $src -O qcow2 $dst
fi

virt-customize -a $dst --root-password file:.rootpassword \
	--run customize.sh --selinux-relabel
