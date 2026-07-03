#!/bin/bash

function installer() {
    if ! command -v "$@" &> /dev/null; then
        echo '[ + ] installing '"$@"
        sudo apt install -y "$@"
    else
        echo '[ - ] '"$@"' installed in your PC'
    fi
}
sudo apt install -y linux-headers-$(uname -r)
sudo sed -i 's/main/main non-free contrib/g' /etc/apt/sources.list
sudo apt update && sudo apt full-upgrade -y
pkg_basic=($(jq -r '.packages[]' config.json))
pkg_next=($(jq -r '.next_Packages[]' config.json))

for basic in "${pkg_basic[@]}"; do
    installer $basic
done

nvidia-detect

for afterkg in "${pkg_next[@]}"; do
    installer $afterkg
done

echo "restart your system Please"
echo "Created By CAgent_47"
