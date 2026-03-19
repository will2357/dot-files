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

install_prerequisites() {
    if [ ! "$(uname)" == "Linux" ]; then
        prn_error "Must be on a debian based Linux system."
        return 1
    fi

    curr_dir=$PWD
    home_dir=$HOME
    temp_dir=/tmp/tmp_install
    server="false"

    export curr_dir home_dir temp_dir server

    if pwd | grep -q /tmp_install$ ;then
        prn_note "Already in a tmp_install directory."
        temp_dir="$curr_dir"
    else
        mkdir -p "$temp_dir"
        cd "$temp_dir" || return 1
    fi

    if [ -z "$(which xset)" ]; then
        server="true"
    fi

    export src_dir="$home_dir/src"
}
