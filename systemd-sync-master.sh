#!/bin/bash

# To use, `sudo cp dot-files-master-sync.service /etc/systemd/system/`
# sudo systemctl enable dot-files-master-sync.service
# sudo systemctl start  dot-files-master-sync.service
# sudo systemctl stop   dot-files-master-sync.service

if [ ! "$(uname)" == "Linux" ]; then echo "Must be on a Linux system."; exit 1; fi

script_dir="$(dirname "$(readlink -f "$0")")"
curr_dir=$PWD

while true
do
    cd "$script_dir" || cd "$curr_dir" || exit 1

    if wget -q --spider http://google.com; then
        printf "Online: "
        git fetch
        git reset --hard origin/master
    else
        printf "Offline: "
    fi

    printf "Sleeping for 60s at: %s\n" "$(date +%H:%M:%S)"
    sleep 60
done
