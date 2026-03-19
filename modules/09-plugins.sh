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

install_plugins() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    if ! which vim 2>/dev/null; then
        prn_note "Vim not installed. Skipping plugin installation."
        return 0
    fi

    prn_note "Installing vim plugins."
    vim_plug="$home_dir/.vim/autoload/plug.vim"
    if [[ ! -f "$vim_plug" ]]; then
        prn_note "Installing 'vim-plug'."
        curl -fLo "$vim_plug" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    vim_solar_dir="$home_dir/.vim/bundle/vim-colors-solarized"
    if [[ ! -d "$vim_solar_dir" ]]; then
        git clone https://github.com/altercation/vim-colors-solarized.git "$vim_solar_dir"
    fi
    vim +'PlugInstall --sync' +qa 2>/dev/null || true

    if which nvim 2>/dev/null; then
        nvim +'PlugInstall --sync' +qa 2>/dev/null || true
    fi
}
