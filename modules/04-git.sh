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

install_git() {
    if [[ $(type -t install_prerequisites) == "function" ]]; then
        install_prerequisites
    fi

    local git_script_dir
    git_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    dotfiles_dir="$git_script_dir/dotfiles"

    prn_note "Configuring git."

    if ! git config user.name 2>/dev/null; then
        while true; do
            git_user_name=""
            get_input "Enter git user.name (blank for default of '$GIT_USER_NAME'): " \
                git_user_name "$GIT_USER_NAME"
            if [[ -n "$git_user_name" ]]; then
                git config --global user.name "$git_user_name"
                break
            fi
            prn_error "Git user.name cannot be empty."
        done
    fi

    if ! git config user.email 2>/dev/null; then
        while true; do
            git_user_email=""
            get_input "Enter git user.email (blank for default of '$GIT_USER_EMAIL'): " \
                git_user_email "$GIT_USER_EMAIL"
            if [[ -n "$git_user_email" ]]; then
                git config --global user.email "$git_user_email"
                break
            fi
            prn_error "Git user.email cannot be empty."
        done
    fi

    git config --global push.default simple
    git config --global color.ui auto
    git config --global core.excludesfile "$home_dir/.gitignore_global"

    if [[ -f "$dotfiles_dir/gitignore_global" ]]; then
        cp "$dotfiles_dir/gitignore_global" "$home_dir/.gitignore_global"
    fi
    git config --global core.editor vim
    git config --global merge.tool vim

    if ! gh auth status 2>/dev/null; then
        prn_note "Logging in to GitHub CLI..."
        if ! gh auth login; then
            prn_error "GitHub CLI authentication failed."
            return 1
        fi
    fi
}
