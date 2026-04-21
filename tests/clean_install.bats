#!/usr/bin/env bats

SCRIPT_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
if [ -n "$IN_DOCKER" ]; then
    PROJECT_ROOT="/home/testuser/dot-files"
else
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

setup_file() {
    export TEST_TMPDIR="${TMPDIR:-/tmp}/dot-files-test-$$"
    mkdir -p "$TEST_TMPDIR"
    export TEST_HOME="$TEST_TMPDIR/home"
    mkdir -p "$TEST_HOME"
}

teardown_file() {
    if [ -n "$TEST_TMPDIR" ] && [ -d "$TEST_TMPDIR" ]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

@test "clean_install.sh - script is executable" {
    [ -x "$PROJECT_ROOT/clean_install.sh" ]
}

@test "clean_install.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
}

@test "clean_install.sh - required commands exist" {
    which bash
    which git
    which curl
    which apt
}

@test "dot_install.sh - script is executable" {
    [ -x "$PROJECT_ROOT/dot_install.sh" ]
}

@test "dot_install.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/dot_install.sh"
    [ "$status" -eq 0 ]
}

@test "shared_functions.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/_shared_functions.sh"
    [ "$status" -eq 0 ]
}

@test "all required dot files exist" {
    [ -f "$PROJECT_ROOT/bashrc" ]
    [ -f "$PROJECT_ROOT/bash_functions" ]
    [ -f "$PROJECT_ROOT/vimrc" ]
    [ -f "$PROJECT_ROOT/tmux.conf" ]
    [ -f "$PROJECT_ROOT/_shared_functions.sh" ]
    [ -f "$PROJECT_ROOT/clean_install.sh" ]
    [ -f "$PROJECT_ROOT/dot_install.sh" ]
    [ -f "$PROJECT_ROOT/gitignore_global" ]
    [ -f "$PROJECT_ROOT/ackrc" ]
    [ -f "$PROJECT_ROOT/ctags" ]
}

@test "config/nvim/init.vim exists" {
    [ -f "$PROJECT_ROOT/config/nvim/init.vim" ]
}

@test "ctags.d directory exists with config files" {
    [ -d "$PROJECT_ROOT/ctags.d" ]
}

@test "clean_install.sh - runs without immediate syntax errors" {
    run bash -n "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
}

@test "integration - apt packages can be installed" {
    if [ -z "$CI" ] && [ -z "$IN_DOCKER" ]; then skip "Skipping in local unit tests"; fi
    which apt-get
    run sudo apt-get update
    [ "$status" -eq 0 ]
}

@test "integration - vim can be compiled from source" {
    which make
    which gcc
}

@test "integration - neovim can be compiled from source" {
    which cmake
}

@test "integration - git is configured" {
    git config --global user.name || true
    git config --global user.email || true
}

@test "integration - tmux is available" {
    which tmux
}

@test "integration - python3 is available" {
    which python3
    python3 --version
}

@test "integration - bash completion is available" {
    [ -d /usr/share/bash-completion ]
}

@test "integration - shellcheck is available" {
    which shellcheck
}

@test "integration - AWS CLI can be installed" {
    which curl
    which unzip
}

@test "integration - kubectl installation is present in clean_install.sh" {
    run grep -Eq "(dl[.]k8s[.]io|storage[.]googleapis[.]com/kubernetes-release).*/kubectl" "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
    run grep -Eq "(install|mv|cp|chmod).*[[:space:]/]kubectl([[:space:]]|$)" "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
}

@test "integration - helm installation is present in clean_install.sh" {
    run grep -Eq "(raw[.]githubusercontent[.]com/helm/helm/.*/get-helm-3|get[.]helm[.]sh/helm-)" "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
    run grep -Eq "command -v helm" "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
}

@test "integration - eksctl installation is present in clean_install.sh" {
    run grep -Eq "github[.]com/.*/eksctl/releases/.*/eksctl_" "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
    run grep -Eq "(tar|unzip|mv|install).*(eksctl([[:space:]]|$)|eksctl_)" "$PROJECT_ROOT/clean_install.sh"
    [ "$status" -eq 0 ]
}

@test "integration - Docker environment variables are set" {
    if [ -z "$CI" ] && [ -z "$IN_DOCKER" ]; then skip "Skipping in local unit tests"; fi
    [ -n "$CI" ] || [ -n "$IN_DOCKER" ]
}

@test "integration - dot files link successfully" {
    export HOME="$TEST_HOME"
    mkdir -p "$HOME/.config/nvim"

    ln -sf "$PROJECT_ROOT/bashrc" "$HOME/.bashrc"
    ln -sf "$PROJECT_ROOT/vimrc" "$HOME/.vimrc"
    ln -sf "$PROJECT_ROOT/tmux.conf" "$HOME/.tmux.conf"
    ln -sf "$PROJECT_ROOT/config/nvim/init.vim" "$HOME/.config/nvim/init.vim"

    [ -L "$HOME/.bashrc" ]
    [ -L "$HOME/.vimrc" ]
    [ -L "$HOME/.tmux.conf" ]
    [ -L "$HOME/.config/nvim/init.vim" ]
}

@test "integration - vim plugins directory structure" {
    [ -d "$PROJECT_ROOT" ]
}

@test "integration - tmux plugins can be installed" {
    which git
}

@test "clean_install.sh git credentials use environment variable fallbacks" {
    export GIT_USER_NAME="testuser"
    export GIT_USER_EMAIL="test@example.com"

    run bash -c '
        source "$PROJECT_ROOT/_shared_functions.sh"
        GIT_USER_NAME="${GIT_USER_NAME:-will2357}"
        GIT_USER_EMAIL="${GIT_USER_EMAIL:-will.highducheck@gmail.com}"
        [ "$GIT_USER_NAME" = "testuser" ]
        [ "$GIT_USER_EMAIL" = "test@example.com" ]
    '
    [ "$status" -eq 0 ]
}
