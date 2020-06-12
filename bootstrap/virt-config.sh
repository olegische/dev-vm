#!/usr/bin/env bash

USER_DSC="Developer"
USER_NM=$SUDO_USER
BRIDGE="br0"
VM_MAC="52:54:00:8a:ea:85"
VM_DIR="/mnt/vm/vm"
DEB_ISO="debian-10.4.0-amd64-netinst.iso"
BUILDER="qemu"
HOSTNAME="dev"
DOMAIN="domain.local"
VM_NAME=$HOSTNAME
VM_RAM="4096"
VM_CPU_NUM="2"
DISK_IMAGE="${VM_DIR}/img/${VM_NAME}.qcow2"
DISK_IMAGE_SIZE="10"
PRESEED_NM="preseed"
PRESEED="${PRESEED_NM}-${BUILDER}-${DISK_IMAGE_SIZE}gb"
INSTALLER_LOCATION="${VM_DIR}/iso/${DEB_ISO}"
