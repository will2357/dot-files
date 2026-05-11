#!/usr/bin/env bats

setup() {
    source "./_shared_functions.sh"
}

# Mocking functions
dpkg() {
    if [[ "$*" == "-l ubuntu-desktop" ]] && [[ "${MOCK_DESKTOP_INSTALLED:-}" == "true" ]]; then
        echo "ii  ubuntu-desktop"
        return 0
    fi
    if [[ "$*" == "-l ubuntu-desktop-minimal" ]] && [[ "${MOCK_DESKTOP_MINIMAL_INSTALLED:-}" == "true" ]]; then
        echo "ii  ubuntu-desktop-minimal"
        return 0
    fi
    if [[ "$*" == "-l gdm3" ]] && [[ "${MOCK_GDM3_INSTALLED:-}" == "true" ]]; then
        echo "ii  gdm3"
        return 0
    fi
    return 1
}

systemctl() {
    if [[ "$*" == "get-default" ]]; then
        echo "${MOCK_TARGET:-multi-user.target}"
        return 0
    fi
    return 1
}

hostnamectl() {
    if [[ "$*" == "status" ]]; then
        echo "Chassis: ${MOCK_CHASSIS:-vm}"
        return 0
    fi
    return 1
}

export -f dpkg systemctl hostnamectl

@test "is_server - returns true for default (multi-user.target, no desktop pkgs)" {
    export MOCK_TARGET="multi-user.target"
    export MOCK_DESKTOP_INSTALLED="false"
    export MOCK_DESKTOP_MINIMAL_INSTALLED="false"
    export MOCK_CHASSIS="vm"
    
    run is_server
    [ "$output" = "true" ]
}

@test "is_server - returns false if ubuntu-desktop is installed" {
    export MOCK_TARGET="multi-user.target"
    export MOCK_DESKTOP_INSTALLED="true"
    
    run is_server
    [ "$output" = "false" ]
}

@test "is_server - returns false if ubuntu-desktop-minimal is installed" {
    export MOCK_DESKTOP_MINIMAL_INSTALLED="true"
    
    run is_server
    [ "$output" = "false" ]
}

@test "is_server - returns false if target is graphical and gdm3 is installed" {
    export MOCK_TARGET="graphical.target"
    export MOCK_GDM3_INSTALLED="true"
    
    run is_server
    [ "$output" = "false" ]
}

@test "is_server - returns true if target is graphical but no display manager or desktop pkgs" {
    export MOCK_TARGET="graphical.target"
    export MOCK_DESKTOP_INSTALLED="false"
    export MOCK_GDM3_INSTALLED="false"
    
    run is_server
    [ "$output" = "true" ]
}

@test "is_server - returns true if chassis is server (even if graphical target is set)" {
    export MOCK_TARGET="graphical.target"
    export MOCK_GDM3_INSTALLED="true"
    export MOCK_CHASSIS="server"
    
    run is_server
    [ "$output" = "true" ]
}
