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

install_vim() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    prn_note "Compiling vim from source."

    sudo apt purge -y vim 2>/dev/null || true
    sudo dpkg --purge --force-all vim 2>/dev/null || true

    cd "$src_dir" || return 1
    sudo rm -rf vim
    git clone https://github.com/vim/vim.git
    cd vim/src/ || return 1

    if grep sources.list.d.ubuntu.sources /etc/apt/sources.list 2>/dev/null; then
        if ! grep -i '^Types: deb-src' /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null; then
            echo "
Types: deb-src
URIs: http://us.archive.ubuntu.com/ubuntu/
Suites: noble noble-updates noble-backports noble-proposed
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" | sudo tee -a /etc/apt/sources.list.d/ubuntu.sources >/dev/null
        fi
    else
        sudo sed -i 's/\#\ deb\-src/deb-src/g' /etc/apt/sources.list 2>/dev/null || true
    fi

    sudo apt update
    sudo apt build-dep -y vim
    sudo ./configure --with-features=huge --enable-multibyte \
        --enable-rubyinterp=yes --enable-python3interp=yes \
        --with-python3-config-dir="$(python3-config --configdir)" \
        --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 \
        --enable-cscope --enable-gui --with-x
    sudo make
    sudo make install
    prn_success "Finished compiling vim from source."
}
