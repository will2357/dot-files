#!/usr/bin/env bats

setup() {
    export TEST_TMPDIR="${BATS_TMPDIR}/systemd-sync-test-$$"
    mkdir -p "$TEST_TMPDIR"
    export PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export SCRIPT_PATH="$PROJECT_ROOT/systemd-sync-master.sh"

    export MOCK_BIN="$TEST_TMPDIR/mockbin"
    mkdir -p "$MOCK_BIN"
    export LOG_FILE="$TEST_TMPDIR/git.log"
    : > "$LOG_FILE"

    cat > "$MOCK_BIN/git" <<'EOF'
#!/bin/bash
set -euo pipefail
echo "$*" >> "${LOG_FILE:?}"

if [ "$1" = "rev-parse" ] && [ "${2:-}" = "--is-inside-work-tree" ]; then
    exit 0
fi

if [ "$1" = "remote" ] && [ "${2:-}" = "get-url" ] && [ "${3:-}" = "origin" ]; then
    echo "git@github.com:will2357/dot-files.git"
    exit 0
fi

if [ "$1" = "ls-remote" ] && [ "${2:-}" = "--heads" ] && [ "${3:-}" = "origin" ] && [ "${4:-}" = "master" ]; then
    [ "${MOCK_ONLINE:-1}" = "1" ] && exit 0
    exit 2
fi

if [ "$1" = "status" ] && [ "${2:-}" = "--porcelain" ]; then
    printf "%s" "${MOCK_STATUS:-}"
    exit 0
fi

if [ "$1" = "rev-parse" ] && [ "${2:-}" = "--abbrev-ref" ] && [ "${3:-}" = "HEAD" ]; then
    echo "${MOCK_BRANCH:-master}"
    exit 0
fi

if [ "$1" = "pull" ] && [ "${2:-}" = "--ff-only" ] && [ "${3:-}" = "origin" ] && [ "${4:-}" = "master" ]; then
    exit "${MOCK_PULL_EXIT:-0}"
fi

exit 0
EOF
    chmod +x "$MOCK_BIN/git"
}

teardown() {
    rm -rf "$TEST_TMPDIR"
}

@test "systemd sync skips update when working tree is dirty" {
    run env \
        PATH="$MOCK_BIN:$PATH" \
        LOG_FILE="$LOG_FILE" \
        MOCK_ONLINE=1 \
        MOCK_STATUS=" M bashrc" \
        MOCK_BRANCH=master \
        SYNC_ONCE=true \
        bash "$SCRIPT_PATH"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Local changes detected; skipping update."* ]]

    run grep -F "pull --ff-only origin master" "$LOG_FILE"
    [ "$status" -ne 0 ]
}

@test "systemd sync fast-forwards master when clean" {
    run env \
        PATH="$MOCK_BIN:$PATH" \
        LOG_FILE="$LOG_FILE" \
        MOCK_ONLINE=1 \
        MOCK_STATUS="" \
        MOCK_BRANCH=master \
        MOCK_PULL_EXIT=0 \
        SYNC_ONCE=true \
        bash "$SCRIPT_PATH"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Updated from origin/master."* ]]

    run grep -F "pull --ff-only origin master" "$LOG_FILE"
    [ "$status" -eq 0 ]
}

@test "systemd sync skips update when branch is not master" {
    run env \
        PATH="$MOCK_BIN:$PATH" \
        LOG_FILE="$LOG_FILE" \
        MOCK_ONLINE=1 \
        MOCK_STATUS="" \
        MOCK_BRANCH=feature-branch \
        SYNC_ONCE=true \
        bash "$SCRIPT_PATH"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Current branch is not 'master'; skipping update."* ]]

    run grep -F "pull --ff-only origin master" "$LOG_FILE"
    [ "$status" -ne 0 ]
}
