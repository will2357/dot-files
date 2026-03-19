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

install_version_managers() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    cd "$src_dir" || return 1

    prn_note "Installing rbenv via rbenv-installer script."
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    prn_success "Installed rbenv."

    prn_note "Installing nvm via nvm-sh installer script."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    prn_success "Installed nvm."

    prn_note "Installing uv via installer script."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    prn_success "Installed uv."
}
