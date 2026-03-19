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

install_cleanup() {
    prn_note "Cleaning up temporary files..."
    cd "$home_dir" || return 1
    sudo rm -rf "$temp_dir"

    prn_note "NOTE:
On desktop install, change terminal colors to solarized dark by going to
the GNOME terminal menu ->
'Preferences' -> 'Profiles|Unnamed' -> 'Colors' ->
Uncheck 'Use colors from system theme'
Select 'Solarized dark' from 'Built-in schemes' in both 'Text and Background' and 'Palette'"
}
