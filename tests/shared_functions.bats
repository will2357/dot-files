#!/usr/bin/env bats

setup() {
    export TERM=xterm
    SCRIPT_DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

    export TEST_TMPDIR="${TMPDIR:-/tmp}/dot-files-test-$$"
    mkdir -p "$TEST_TMPDIR"
    export TEST_HOME="$TEST_TMPDIR/home"
    mkdir -p "$TEST_HOME"

    export DEBIAN_FRONTEND=noninteractive
}

teardown() {
    if [ -n "$TEST_TMPDIR" ] && [ -d "$TEST_TMPDIR" ]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

get_confirmation() {
    if [ -n "$BATS_TEST_CONFIRMED" ]; then
        printf "Response: y\n"
        return 0
    fi
    printf "Response: n\n"
    return 1
}

get_input() {
    return 1
}

stub_get_confirmation() {
    get_confirmation() {
        printf "Response: y\n"
        return 0
    }
}

stub_get_confirmation_always_no() {
    get_confirmation() {
        printf "Response: n\n"
        return 1
    }
}

@test "prn_error outputs red colored text" {
    source "$PROJECT_ROOT/_shared_functions.sh"

    run prn_error "test error message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"test error message"* ]]
    [[ "$output" == *$'\033[31m'* ]]
}

@test "prn_success outputs green colored text" {
    source "$PROJECT_ROOT/_shared_functions.sh"

    run prn_success "test success message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"test success message"* ]]
    [[ "$output" == *$'\033[32m'* ]]
}

@test "prn_note outputs blue colored text" {
    source "$PROJECT_ROOT/_shared_functions.sh"

    run prn_note "test note message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"test note message"* ]]
    [[ "$output" == *$'\033[34m'* ]]
}

@test "get_confirmation returns 0 for yes response" {
    source "$PROJECT_ROOT/_shared_functions.sh"
    stub_get_confirmation

    run get_confirmation "Test prompt?"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Response: y"* ]]
}

@test "get_confirmation returns 1 for no response" {
    source "$PROJECT_ROOT/_shared_functions.sh"
    stub_get_confirmation_always_no

    run get_confirmation "Test prompt?"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Response: n"* ]]
}
