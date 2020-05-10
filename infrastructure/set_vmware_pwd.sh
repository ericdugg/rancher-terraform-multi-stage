# !/bin/bash

echo -n Username:
read username
echo -n Password:
read -s password
echo

export VSPHERE_USER=${username}
export VSPHERE_PASSWORD=${password}
