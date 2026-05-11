#!/usr/bin/env bats

SCRIPT_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

setup_file() {
    export TERM=xterm
    export TEST_TMPDIR="${TMPDIR:-/tmp}/dot-files-test-$$"
    mkdir -p "$TEST_TMPDIR"
    export TEST_HOME="$TEST_TMPDIR/home"
    mkdir -p "$TEST_HOME"

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

@test "av prints error when activate not found" {
    mkdir -p "$TEST_PROJECT/.venv/bin"

    run bash -i -c '
        cd "$TEST_PROJECT"
        source bashrc
        av 2>&1
    '
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error"* ]]
    [[ "$output" == *"uv sync"* ]]
}

@test "av prints success with path when activate exists" {
    echo "# fake activate" > "$TEST_PROJECT/.venv/bin/activate"

    run bash -i -c '
        cd "$TEST_PROJECT"
        source bashrc
        av 2>&1
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *".venv/bin/activate"* ]]
    [[ "$output" == *"Activated"* ]]
}

@test "av sets VIRTUAL_ENV when activated" {
    printf '#!/bin/bash\nVIRTUAL_ENV="%s/.venv"\n' "$TEST_PROJECT" > "$TEST_PROJECT/.venv/bin/activate"

    run bash -i -c '
        cd "$TEST_PROJECT"
        source bashrc
        av 2>&1
        echo "VIRTUAL_ENV=$VIRTUAL_ENV"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"VIRTUAL_ENV=$TEST_PROJECT/.venv"* ]]
}

@test "recurse-replace performs literal replacement after confirmation" {
    cat > "$TEST_TMPDIR/mock-ack" <<'EOF'
#!/bin/bash
set -euo pipefail
if [ "${1:-}" = "-l" ]; then
    shift
fi
if [ "${1:-}" = "--" ]; then
    shift
fi
pattern=${1:-}
if [ -z "$pattern" ]; then
    exit 1
fi
grep -R --exclude-dir=.git -l -- "$pattern" .
EOF
    chmod +x "$TEST_TMPDIR/mock-ack"
    mkdir -p "$TEST_TMPDIR/mockbin"
    mv "$TEST_TMPDIR/mock-ack" "$TEST_TMPDIR/mockbin/ack"

    printf "alpha1\n" > "$TEST_PROJECT/replace_target.txt"
    run bash -i -c '
        cd "$TEST_PROJECT"
        export PATH="$TEST_TMPDIR/mockbin:$PATH"
        source bashrc
        printf "y\n" | recurse-replace "alpha1" "beta\$2"
        cat replace_target.txt
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *'beta$2'* ]]
}

@test "recurse-replace exits non-zero when canceled" {
    cat > "$TEST_TMPDIR/mock-ack" <<'EOF'
#!/bin/bash
set -euo pipefail
if [ "${1:-}" = "-l" ]; then
    shift
fi
if [ "${1:-}" = "--" ]; then
    shift
fi
pattern=${1:-}
if [ -z "$pattern" ]; then
    exit 1
fi
grep -R --exclude-dir=.git -l -- "$pattern" .
EOF
    chmod +x "$TEST_TMPDIR/mock-ack"
    mkdir -p "$TEST_TMPDIR/mockbin"
    mv "$TEST_TMPDIR/mock-ack" "$TEST_TMPDIR/mockbin/ack"

    printf "keepme\n" > "$TEST_PROJECT/replace_target_cancel.txt"
    run bash -i -c '
        cd "$TEST_PROJECT"
        export PATH="$TEST_TMPDIR/mockbin:$PATH"
        source bashrc
        printf "n\n" | recurse-replace "keepme" "changed"
        echo "status=$?"
        cat replace_target_cancel.txt
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"status=1"* ]]
    [[ "$output" == *"keepme"* ]]
}
