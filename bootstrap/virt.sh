#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

BUILDER="qemu"
HOSTNAME="dev"
DOMAIN="domain.local"
VM_NAME=$HOSTNAME
VM_RAM="4096"
VM_CPU_NUM="2"
DISK_IMAGE="/mnt/vm/vm/img/${VM_NAME}.qcow2"
#DISK_IMAGE_SIZE="5"
DISK_IMAGE_SIZE="10"
PRESEED_NM="preseed"
PRESEED="${PRESEED_NM}-${BUILDER}-${DISK_IMAGE_SIZE}gb"
#INSTALLER_LOCATION="http://ftp.debian.org/debian/dists/stable/main/installer-amd64/"
INSTALLER_LOCATION="/mnt/vm/vm/iso/debian-10.4.0-amd64-netinst.iso"
ARG_AUTO="auto=true"
#ARG_PRIORITY="priority=critcal"
#ARG_PRIORITY="priority=high"
ARG_PRIORITY=""
# hostname and domain command loads from preseed after network options,
# so we need to set them in extra args
#ARG_NETCFG="netcfg/get_hostname?=$HOSTNAME netcfg/get_domain?=$DOMAIN" # with questions
ARG_NETCFG="netcfg/get_hostname=$HOSTNAME netcfg/get_domain=$DOMAIN"
ARG_URL="preseed/url=https://gl.dev.boquar.com/olegrom/site-config/-/raw/master/bootstrap/preseed/${PRESEED}.cfg"
#ARG_URL="auto url=https://gl.dev.boquar.com/olegrom/site-config/-/raw/master/bootstrap/preseed/${PRESEED}.cfg"
EXTRA_ARGS="$ARG_AUTO $ARG_PRIORITY $ARG_NETCFG $ARG_URL"
#EXTRA_ARGS="$ARG_NETCFG $ARG_URL"

source $SCRIPT_DIR/lib/const.sh
source $SCRIPT_DIR/lib/common.sh

USAGE_TXT="Install or remove VM"

usage( )
{
    cat <<EOF
$USAGE_TXT
Usage:
    $PROGRAM [ --? ]
        [ --help ]
        [ --version ]
        [ --install ]
        [ --remove ]
        [ --echo ]
    --install
      Install VM

    --remove
      Remove VM

    --echo
      Echo mode without execution
EOF
}

PROGRAM=`basename $0`
VERSION=1.0
TMP_FILE="/tmp/${PROGRAM}"

if [ $( whoami ) != 'root' ]; then
    error "Run script as root user."
fi

if [ $# -eq 0 ]; then
    error "Choose required option for script."
fi

cmnd="no"
echo="no"
while test $# -gt 0
do
    case $1 in
    --install | --instal | --insta | --inst | --ins | --in | --i | \
    -install | -instal | -insta | -inst | -ins | -in | -i )
        cmnd='install'
        ;;
    --remove | --remov | --remo | --rem | --re | --r | \
    -remove | -remov | -remo | -rem | -re | -r )
        cmnd='remove'
        ;;
    --help | --hel | --he | --h | '--?' | -help | -hel | -he | -h | '-?' )
        usage_and_exit 0
        ;;
    --version | --versio | --versi | --vers | --ver | --ve | --v | \
    -version | -versio | -versi | -vers | -ver | -ve | -v )
        version
        exit 0
        ;;
    --echo | --ech | --ec | --e | \
    -echo | -ech | -ec | -e )
        echo="yes"
        ;;
    -*)
        error "Unrecognized option: $1."
        ;;
    *)
        break
        ;;
    esac
    shift
done

# Sanity checks for error conditions
if [ $cmnd == 'no' ]; then
    error "Please, choose --install or --remove option."
fi

function virt() {
    cmnd=$1 && shift
    if [ $cmnd == 'install' ]; then
        echo "virt-install \
            --virt-type kvm \
            --name $VM_NAME \
            --location=$INSTALLER_LOCATION \
            --extra-args=\"$EXTRA_ARGS\" \
            --memory $VM_RAM \
            --vcpus $VM_CPU_NUM \
            --network bridge=br0,mac=52:54:00:8a:ea:85 \
            --disk ${DISK_IMAGE},format=qcow2,size=${DISK_IMAGE_SIZE} \
            --graphics vnc \
            --os-variant debian10"
    elif [ $cmnd == 'remove' ]; then
        echo "virsh destroy $VM_NAME"
        echo "virsh undefine $VM_NAME"
        echo "rm -f $DISK_IMAGE"
    fi
}

exec 3>$TMP_FILE
#virt $cmnd >&3
virt $cmnd |
while read op; do
    echo $op >&3
done
exec 3>&-
exec 0< $TMP_FILE
if [ $echo == 'yes' ]; then
    cat
elif [ $echo == "no" ]; then
    while read op; do
        echo $op | sh
    done
fi
rm $TMP_FILE

exit 0
