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

install_dotfiles() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    cd "$src_dir" || return 1
    mkdir -p "$src_dir"
    dot_dir="$src_dir/dot-files"

    if [[ ! -d "$dot_dir" ]]; then
        git clone https://github.com/will2357/dot-files.git "$dot_dir"
    fi
    cd "$dot_dir" || return 1

    if [[ $(git status --porcelain) ]]; then
        prn_error "Changes in local git repo. Exiting now."
        return 1
    fi

    prn_note "All branches in this repo: "
    git branch -a

    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "master")
    git_dot_files_branch=""
    get_input "Enter branch for dot files installation (blank for default of '$current_branch'): " \
        git_dot_files_branch "$current_branch"
    git checkout "$git_dot_files_branch"

    prn_note "Running 'dot_install.sh' script with default options."

    chmod u+x "$dot_dir/dot_install.sh"
    "$dot_dir/dot_install.sh"
}
