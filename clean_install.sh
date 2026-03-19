#!/bin/bash

set -eu

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/_shared_functions.sh"

GIT_USER_NAME="${GIT_USER_NAME:-will2357}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-will.highducheck@gmail.com}"

for module in "$script_dir"/modules/[0-9][0-9]-*.sh; do
    source "$module"
done

install_prerequisites
install_packages
install_ctags
install_chrome
install_git
install_vim
install_neovim
install_dotfiles
install_version_managers
install_plugins
install_tmux_mem_cpu
install_aws_cli
install_cleanup

prn_success "SUCCESS: Ran 'clean_install.sh' script without errors."

exit 0
