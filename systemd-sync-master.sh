#!/bin/bash

set -euo pipefail

# To use, `sudo cp dot-files-master-sync.service /etc/systemd/system/`
# sudo systemctl enable dot-files-master-sync.service
# sudo systemctl start  dot-files-master-sync.service
# sudo systemctl stop   dot-files-master-sync.service

if [ ! "$(uname)" == "Linux" ]; then
    echo "Must be on a Linux system."
    exit 1
fi

script_dir="$(dirname "$(readlink -f "$0")")"
curr_dir=$PWD
sync_interval_seconds="${SYNC_INTERVAL_SECONDS:-60}"
sync_once="${SYNC_ONCE:-false}"

while true
do
    cd "$script_dir" || cd "$curr_dir" || exit 1

    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        printf "Error: '%s' is not a git repository.\n" "$PWD" >&2
    elif ! git remote get-url origin >/dev/null 2>&1; then
        printf "Error: git remote 'origin' is not configured.\n" >&2
    elif git ls-remote --heads origin master >/dev/null 2>&1; then
        printf "Online: "
        if [ -n "$(git status --porcelain)" ]; then
            printf "Local changes detected; skipping update.\n"
        elif [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ]; then
            printf "Current branch is not 'master'; skipping update.\n"
        elif git pull --ff-only origin master >/dev/null 2>&1; then
            printf "Updated from origin/master.\n"
        else
            printf "Unable to fast-forward master; skipping update.\n"
        fi
    else
        printf "Offline: could not reach origin/master.\n"
    fi

    if [ "$sync_once" = "true" ]; then
        break
    fi

    printf "Sleeping for %ss at: %s\n" "$sync_interval_seconds" "$(date +%H:%M:%S)"
    sleep "$sync_interval_seconds"
done
