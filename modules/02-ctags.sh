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

install_ctags() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    prn_note "Installing universal-ctags from source."

    cd "$temp_dir" || return 1
    if which ctags 2>/dev/null; then
        sudo apt purge -y exuberant-ctags
        sudo dpkg --purge --force-all exuberant-ctags 2>/dev/null || true
        sudo apt purge -y ctags
        sudo dpkg --purge --force-all ctags 2>/dev/null || true
    fi
    sudo rm -rf ctags
    git clone https://github.com/universal-ctags/ctags.git
    cd ctags || exit 1
    ./autogen.sh
    ./configure
    make
    sudo checkinstall -y
    prn_success "Installed universal-ctags."
}
