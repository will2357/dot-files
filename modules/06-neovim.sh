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

install_neovim() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    prn_note "Compiling neovim from source."

    sudo apt purge -y neovim 2>/dev/null || true
    sudo dpkg --purge --force-all neovim 2>/dev/null || true

    cd "$src_dir" || return 1
    sudo rm -rf neovim
    git clone https://github.com/neovim/neovim.git
    cd neovim/ || return 1
    git checkout stable

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    prn_success "Finished compiling neovim from source."
}
