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

install_packages() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    prn_note "Installing packages via apt..."

    sudo apt update

    export DEBIAN_FRONTEND=noninteractive
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

    sudo apt install -y \
        ack \
        autoconf \
        automake \
        bash-completion \
        build-essential \
        checkinstall \
        cmake \
        curl \
        git \
        gh \
        htop \
        jq \
        libcurl3-gnutls \
        libcurl4-openssl-dev \
        libncurses5-dev \
        libreadline6-dev \
        libssl-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        open-vm-tools \
        pkg-config \
        python-is-python3 \
        python3 \
        python3-dev \
        python3-pip \
        shellcheck \
        ssh \
        tmux \
        ubuntu-restricted-addons \
        ubuntu-restricted-extras \
        unzip \
        xclip \
        zlib1g \
        zlib1g-dev

    prn_success "Installed packages via apt."

    if [[ "$server" != "true" ]]; then
        sudo apt -y install ddccontrol gddccontrol ddccontrol-db i2c-tools
    fi
}
