#!/bin/bash

is_server () {
    local verbose=${1:-false}
    local server="true"

    if [ "$verbose" = "true" ]; then echo "Starting server detection..."; fi

    if dpkg -l ubuntu-desktop 2>/dev/null | grep -q '^ii' || \
       dpkg -l ubuntu-desktop-minimal 2>/dev/null | grep -q '^ii'; then
        if [ "$verbose" = "true" ]; then echo "Desktop packages found via dpkg."; fi
        server="false"
    elif [ "$(systemctl get-default 2>/dev/null)" = "graphical.target" ]; then
        if [ "$verbose" = "true" ]; then echo "Systemd target is 'graphical.target'. Checking for display managers..."; fi
        # If the target is graphical, verify if a display manager is actually installed
        if dpkg -l gdm3 2>/dev/null | grep -q '^ii' || \
           dpkg -l lightdm 2>/dev/null | grep -q '^ii' || \
           dpkg -l sddm 2>/dev/null | grep -q '^ii'; then
            if [ "$verbose" = "true" ]; then echo "Display manager found."; fi
            server="false"
        else
            if [ "$verbose" = "true" ]; then echo "No display manager found despite graphical target."; fi
        fi
    fi

    # Final check: if hostnamectl explicitly reports 'server' chassis, trust it
    local chassis
    chassis=$(hostnamectl status 2>/dev/null | grep "Chassis:" | awk '{print $2}')
    if [ "$chassis" = "server" ]; then
        if [ "$verbose" = "true" ]; then echo "hostnamectl reports 'server' chassis. Overriding result to server=true."; fi
        server="true"
    elif [ "$verbose" = "true" ] && [ -n "$chassis" ]; then
        echo "hostnamectl reports chassis: $chassis"
    fi

    if [ "$verbose" = "true" ]; then echo "Final detection result: server=$server"; fi
    echo "$server"
}

# If the script is run directly (not sourced), run the detection with verbose output
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    is_server true
fi
