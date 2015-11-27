#!/bin/sh

# Convert vmdk to a deployable dmg

set -e

cleanup ()
{
    [ -n "$device" ] && hdiutil detach "$device"
}

trap cleanup EXIT

vmdk_path=$1
dmg_path=${2:-image.dmg}

if [ -z "$vmdk_path" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];
then
    echo "Usage: vmdk2dmg /path/to/vmdk [/path/to/dmg]"
    exit 1
fi

device=$(vdmutil attach "$vmdk_path" | head -n 1)

echo "==> Mount as $device"
echo "==> Converting to $dmg_path"
hdiutil create -srcdevice "$device" -format UDZO "$dmg_path"
