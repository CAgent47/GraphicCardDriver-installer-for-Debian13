#!/bin/bash
CONFIG_FILE="${1:-config.json}"

# -------------- Installing Package if Not Exists -------------
installer() {
    local pkg="$1"
    if dpkg -s "$pkg" &> /dev/null; then
        echo "[ - ] '$pkg' Installed in your System"
    else
        echo "[ + ] Installing '$pkg' ..."
        if ! sudo apt install -y "$pkg"; then
            echo "[ERROR]: failed to install $pkg"
            exit 1
        fi
    fi
}

# ---------- prerequisite ----------
if ! command -v jq &> /dev/null; then
    sudo apt update && sudo apt install -y jq
fi

if [[ ! -f "$CONFIG_FILE" ]]; then

    if [[ ! -f "confcreator.py" ]]; then
        echo "[ Python Error ]: Conf Create File Not Exists Please Goto https://github.com/CAgent47/GraphicCardDriver-installer-for-Debian13 and Download '*.py' file Please"
        exit 1
    fi
    
    echo "[FiX]: File $CONFIG_FILE Not Found Creating File." >&2
    if ! command -v python3 &> /dev/null; then
        sudo apt install -y python3-full
    fi
    python3 confcreator.py
fi

# ---------------- OS --------------------
if [[ -f /etc/os-release ]] && grep -qi '^ID=debian' /etc/os-release; then
    if ! grep -q 'non-free' /etc/apt/sources.list 2>/dev/null; then
        echo "adding non-free and contrib to sources.list (Debian) ..."
        sudo sed -i 's/ main$/ main non-free contrib/' /etc/apt/sources.list
    else
        echo "non-free Activated"
    fi
else
    echo "your opration system is not Debian."
fi

if [ $(jq -r '.sysUpdate' "$CONFIG_FILE") = "true" ]; then
    sudo apt update && sudo apt full-upgrade -y
fi

# ---------- Read Json File ----------
mapfile -t pkg_basic < <(jq -r '.packages[]' "$CONFIG_FILE")
mapfile -t pkg_next  < <(jq -r '.next_packages[]' "$CONFIG_FILE")


installer "linux-headers-$(uname -r)"

for basic in "${pkg_basic[@]}"; do
    installer "$basic"
done

if command -v nvidia-detect &> /dev/null; then
    nvidia-detect
else
    sudo apt install -y nvidia-detect
fi

for pkg in "${pkg_next[@]}"; do
    installer "$pkg"
done

echo "please restart your System"
echo "Created By CAgent_47"
