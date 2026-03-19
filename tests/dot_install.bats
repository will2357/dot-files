#!/usr/bin/env bats

SCRIPT_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

setup_file() {
    export TEST_TMPDIR="${TMPDIR:-/tmp}/dot-files-test-$$"
    mkdir -p "$TEST_TMPDIR"
    export TEST_HOME="$TEST_TMPDIR/home"
    mkdir -p "$TEST_HOME"

    export DEBIAN_FRONTEND=noninteractive

    export TEST_PROJECT="$TEST_TMPDIR/dot-files"
    cp -a "$PROJECT_ROOT" "$TEST_PROJECT"
    chmod -R u+w "$TEST_PROJECT"
}

teardown_file() {
    if [ -n "$TEST_TMPDIR" ] && [ -d "$TEST_TMPDIR" ]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

setup() {
    export HOME="$TEST_HOME"
}

teardown() {
    find "$TEST_HOME" -mindepth 1 -maxdepth 1 -exec rm -rf {} \; 2>/dev/null || true
    if [ -d "$TEST_PROJECT" ]; then
        rm -rf "$TEST_PROJECT"
        cp -a "$PROJECT_ROOT" "$TEST_TMPDIR/"
        chmod -R u+w "$TEST_PROJECT"
    fi
}

@test "dot_install.sh -h shows help" {
    run bash "$TEST_PROJECT/dot_install.sh" -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"Options:"* ]]
    [[ "$output" == *"-c"* ]]
    [[ "$output" == *"-d"* ]]
    [[ "$output" == *"-f"* ]]
    [[ "$output" == *"-h"* ]]
}

@test "dot_install.sh -d does dry-run without making changes" {
    echo "test bashrc content" > "$TEST_PROJECT/bashrc"

    run bash "$TEST_PROJECT/dot_install.sh" -d -f bashrc <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [ ! -L "$TEST_HOME/.bashrc" ]
    [ ! -f "$TEST_HOME/.bashrc" ]
}

@test "dot_install.sh parses -c flag for copy mode" {
    echo "test bashrc content" > "$TEST_PROJECT/bashrc"

    run bash "$TEST_PROJECT/dot_install.sh" -c -f bashrc <<< $'y\ny\ny'
    [ "$status" -eq 0 ]

    [ -f "$TEST_HOME/.bashrc" ]
    [ ! -L "$TEST_HOME/.bashrc" ]
}

@test "dot_install.sh creates symlink by default" {
    echo "test bashrc content" > "$TEST_PROJECT/bashrc"

    run bash "$TEST_PROJECT/dot_install.sh" -f bashrc <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [ -L "$TEST_HOME/.bashrc" ]
}

@test "dot_install.sh creates backup of existing file" {
    echo "existing content" > "$TEST_HOME/.bashrc"
    echo "new content" > "$TEST_PROJECT/bashrc"

    run bash "$TEST_PROJECT/dot_install.sh" -f bashrc <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [ -f "$TEST_HOME/.bashrc.BAK" ]
    [ "$(cat "$TEST_HOME/.bashrc.BAK")" = "existing content" ]
}

@test "dot_install.sh handles subdirectory files" {
    mkdir -p "$TEST_PROJECT/config/nvim"
    echo "nvim config" > "$TEST_PROJECT/config/nvim/init.vim"

    run bash "$TEST_PROJECT/dot_install.sh" -f "config/nvim/init.vim" <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [ -L "$TEST_HOME/.config/nvim/init.vim" ]
}

@test "dot_install.sh fails on missing file" {
    run bash "$TEST_PROJECT/dot_install.sh" -f nonexistent_file.sh <<< $'y\nn\ny'
    [ "$status" -eq 1 ]
    [[ "$output" == *"does not exist"* ]]
}

@test "dot_install.sh default file list includes expected files" {
    run bash "$TEST_PROJECT/dot_install.sh" <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [[ "$output" == *"default list"* ]]
}

@test "dot_install.sh accepts multiple files with -f" {
    echo "bashrc" > "$TEST_PROJECT/bashrc"
    echo "vimrc" > "$TEST_PROJECT/vimrc"

    run bash "$TEST_PROJECT/dot_install.sh" -f bashrc -- vimrc <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [ -L "$TEST_HOME/.bashrc" ]
    [ -L "$TEST_HOME/.vimrc" ]
}

@test "dot_install.sh handles invalid option" {
    run bash "$TEST_PROJECT/dot_install.sh" -z
    [ "$status" -eq 1 ]
    [[ "$output" == *"Options:"* ]]
}

@test "dot_install.sh backs up existing symlink target" {
    echo "original content" > "$TEST_PROJECT/bashrc"
    echo "symlink target content" > "$TEST_HOME/.bashrc_link_target"
    ln -sf "$TEST_HOME/.bashrc_link_target" "$TEST_HOME/.bashrc"

    run bash "$TEST_PROJECT/dot_install.sh" -f bashrc <<< $'y\ny\ny'
    [ "$status" -eq 0 ]

    [ -f "$TEST_HOME/.bashrc.BAK" ]
}

@test "dot_install.sh overwrites existing symlink" {
    echo "test bashrc content" > "$TEST_PROJECT/bashrc"
    echo "old target content" > "$TEST_HOME/.bashrc_old_target"
    ln -sf "$TEST_HOME/.bashrc_old_target" "$TEST_HOME/.bashrc"

    run bash "$TEST_PROJECT/dot_install.sh" -f bashrc <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [ -L "$TEST_HOME/.bashrc" ]
    [ "$(readlink "$TEST_HOME/.bashrc")" == "$TEST_PROJECT/bashrc" ]
}

@test "dot_install.sh outputs backup message" {
    echo "existing content" > "$TEST_HOME/.bashrc"
    echo "new content" > "$TEST_PROJECT/bashrc"

    run bash "$TEST_PROJECT/dot_install.sh" -f bashrc <<< $'y\nn\ny'
    [ "$status" -eq 0 ]

    [[ "$output" == *"Running 'cp"* ]]
    [[ "$output" == *"Running 'ln -sf"* ]]
}
