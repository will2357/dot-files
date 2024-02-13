#!/bin/bash

# To use, `sudo cp dot-files-master-sync.service /etc/systemd/system/`
# sudo systemctl enable dot-files-master-sync.service
# sudo systemctl start  dot-files-master-sync.service
# sudo systemctl stop   dot-files-master-sync.service

set -e

if [ ! "$(uname)" == "Linux" ]; then echo "Must be on a Linux system."; exit 1; fi

script_dir="$(dirname "$(readlink -f "$0")")"
curr_dir=$PWD

while true
do
    cd "$script_dir" || exit 1
    git fetch
    git reset --hard origin/master
    cd "$curr_dir" || exit 1
    echo SLEEPING FOR 60s
    date
    sleep 60
done
