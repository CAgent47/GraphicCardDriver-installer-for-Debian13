#!/bin/bash

sudo sed -i 's/main/main non-free contrib/g' /etc/apt/sources.list
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y linux-headers-$(uname -r) build-essential dkms nvidia-detect
nvidia-detect
sudo apt install -y nvidia-driver nvidia-kernel-dkms
echo "restart your system Please"
echo "Created By CAgent_47"
