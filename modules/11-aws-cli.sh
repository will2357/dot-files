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

install_aws_cli() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    prn_note "Installing AWS CLI from AmazonAWS.com."

    if which yum 2>/dev/null; then
        sudo yum remove awscli 2>/dev/null || true
    fi
    sudo apt purge awscli 2>/dev/null || true
    cd "$temp_dir" || return 1

    if which aws 2>/dev/null; then
        prn_note "AWS CLI already installed."
        resp=$(get_confirmation "Do you wish to update the AWS CLI?")
        if [[ -n "$resp" ]]; then
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip -q awscliv2.zip
            sudo ./aws/install --update
            prn_success "Updated AWS CLI."
        fi
    else
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip -q awscliv2.zip
        sudo ./aws/install
        prn_success "Installed AWS CLI."
    fi
}
