import os
import json

configuration = {
    "packages": [
        "build-essential",
        "dkms",
        "nvidia-detect"
    ],
    "next_packages": [
        "nvidia-driver",
        "nvidia-kernel-dkms"
    ]
}

if os.path.exists('config.json'):
    print("[ PYTHON NOTE ]: configuration file exists")
else:
    with open('config.json', 'w') as packages:
        json.dump(configuration, packages, indent=4)
        print("[ PYTHON NOTE ]: configuration file created Runing Shell Code!")
