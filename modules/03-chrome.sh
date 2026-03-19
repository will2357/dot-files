#!/bin/bash

module_guard() {
    local guard_error=false
    if [[ -z "${BASH_SOURCE[0]}" || "${BASH_SOURCE[0]}" == "${0}" ]]; then
        guard_error=true
    fi
    if $guard_error; then
        echo "This module must be sourced. Usage: source ${BASH_SOURCE[0]}"
        exit 1
    fi
}
module_guard
unset module_guard

install_chrome() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    if [[ "$server" == "true" ]]; then
        prn_note "Skipping Chrome installation on server."
        return 0
    fi

    prn_note "Installing Google Chrome web browser."
    resp=$(get_confirmation "Are you sure you wish to install Google Chrome?")
    if [[ -z "$resp" ]]; then
        return 0
    fi

    install_chrome_impl() {
        google_list="/etc/apt/sources.list.d/google.list"

        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null

        if ! grep -q 'dl.google.com' "$google_list" 2>/dev/null; then
            sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> '"$google_list"
        fi

        sudo apt update
        sudo apt install google-chrome-stable
    }

    if [[ -z "$(which google-chrome-stable 2>/dev/null)" ]]; then
        install_chrome_impl
    else
        prn_note "'google-chrome-stable' already installed. Skipping."
    fi

    if which google-chrome-stable 2>/dev/null; then
        BROWSER="$(which google-chrome-stable)"
        export BROWSER
    fi
}
