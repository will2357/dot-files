#!/usr/bin/env bats

setup() {
    export TERM=xterm
    SCRIPT_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
}

teardown() {
    if [ -n "$TEST_TMPDIR" ] && [ -d "$TEST_TMPDIR" ]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

@test "modules/00-prerequisites.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/00-prerequisites.sh" ]
}

@test "modules/00-prerequisites.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/00-prerequisites.sh"
    [ "$status" -eq 0 ]
}

@test "modules/01-packages.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/01-packages.sh" ]
}

@test "modules/01-packages.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/01-packages.sh"
    [ "$status" -eq 0 ]
}

@test "modules/02-ctags.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/02-ctags.sh" ]
}

@test "modules/02-ctags.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/02-ctags.sh"
    [ "$status" -eq 0 ]
}

@test "modules/03-chrome.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/03-chrome.sh" ]
}

@test "modules/03-chrome.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/03-chrome.sh"
    [ "$status" -eq 0 ]
}

@test "modules/04-git.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/04-git.sh" ]
}

@test "modules/04-git.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/04-git.sh"
    [ "$status" -eq 0 ]
}

@test "modules/05-vim.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/05-vim.sh" ]
}

@test "modules/05-vim.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/05-vim.sh"
    [ "$status" -eq 0 ]
}

@test "modules/06-neovim.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/06-neovim.sh" ]
}

@test "modules/06-neovim.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/06-neovim.sh"
    [ "$status" -eq 0 ]
}

@test "modules/07-dotfiles.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/07-dotfiles.sh" ]
}

@test "modules/07-dotfiles.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/07-dotfiles.sh"
    [ "$status" -eq 0 ]
}

@test "modules/08-version-managers.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/08-version-managers.sh" ]
}

@test "modules/08-version-managers.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/08-version-managers.sh"
    [ "$status" -eq 0 ]
}

@test "modules/09-plugins.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/09-plugins.sh" ]
}

@test "modules/09-plugins.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/09-plugins.sh"
    [ "$status" -eq 0 ]
}

@test "modules/10-tmux-mem-cpu.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/10-tmux-mem-cpu.sh" ]
}

@test "modules/10-tmux-mem-cpu.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/10-tmux-mem-cpu.sh"
    [ "$status" -eq 0 ]
}

@test "modules/11-aws-cli.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/11-aws-cli.sh" ]
}

@test "modules/11-aws-cli.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/11-aws-cli.sh"
    [ "$status" -eq 0 ]
}

@test "modules/12-cleanup.sh - script is executable" {
    [ -x "$PROJECT_ROOT/modules/12-cleanup.sh" ]
}

@test "modules/12-cleanup.sh - syntax check" {
    run bash -n "$PROJECT_ROOT/modules/12-cleanup.sh"
    [ "$status" -eq 0 ]
}

@test "all modules exist" {
    [ -f "$PROJECT_ROOT/modules/00-prerequisites.sh" ]
    [ -f "$PROJECT_ROOT/modules/01-packages.sh" ]
    [ -f "$PROJECT_ROOT/modules/02-ctags.sh" ]
    [ -f "$PROJECT_ROOT/modules/03-chrome.sh" ]
    [ -f "$PROJECT_ROOT/modules/04-git.sh" ]
    [ -f "$PROJECT_ROOT/modules/05-vim.sh" ]
    [ -f "$PROJECT_ROOT/modules/06-neovim.sh" ]
    [ -f "$PROJECT_ROOT/modules/07-dotfiles.sh" ]
    [ -f "$PROJECT_ROOT/modules/08-version-managers.sh" ]
    [ -f "$PROJECT_ROOT/modules/09-plugins.sh" ]
    [ -f "$PROJECT_ROOT/modules/10-tmux-mem-cpu.sh" ]
    [ -f "$PROJECT_ROOT/modules/11-aws-cli.sh" ]
    [ -f "$PROJECT_ROOT/modules/12-cleanup.sh" ]
}
