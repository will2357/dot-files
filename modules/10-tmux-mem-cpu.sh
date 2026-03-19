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

install_tmux_mem_cpu() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    prn_note "Compiling tmux-mem-cpu-load from source."

    cd "$src_dir" || return 1
    rm -rf "$src_dir/tmux-mem-cpu-load"
    git clone https://github.com/thewtex/tmux-mem-cpu-load.git
    cd tmux-mem-cpu-load || return 1

    cmake .
    make
    sudo make install

    prn_success "Finished compiling tmux-mem-cpu-load from source."

    tmux_plugin_man_dir="$home_dir/.tmux/plugins/tpm"
    if [[ ! -d "$tmux_plugin_man_dir" ]]; then
        prn_note "Installing tpm for tmux."
        git clone https://github.com/tmux-plugins/tpm "$tmux_plugin_man_dir"
    fi

    tmux start-server
    tmux new-session -d
    prn_note "Installing tmux plugins."
    "$tmux_plugin_man_dir/scripts/install_plugins.sh"
}
