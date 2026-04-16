#!/bin/bash

set -euo pipefail

color_normal=$(tput sgr0)

prn_error () {
    local error_message=$1
    local color_red
    color_red=$(tput setaf 1)
    printf "\n%s\n" "${color_red}$error_message${color_normal}"
}

prn_success () {
    local success_message=$1
    local color_green
    color_green=$(tput setaf 2)
    printf "\n%s\n" "${color_green}$success_message${color_normal}"
}

prn_note () {
    local color_blue
    color_blue=$(tput setaf 4)
    local note_message=$1
    printf "\n%s\n" "${color_blue}$note_message${color_normal}"
}

get_confirmation () {
    [ -z "$1" ] && prn_error "Must include a message for the user. Exiting." && exit 1
    local message=$1
    local bold_message
    bold_message="$(tput bold)$message (y/N) ${color_normal}"

    read -r -p "$bold_message" yn
    case $yn in
        [Yy]* ) printf "Response: %s\n" "$yn"; return 0;;
    esac
    return 1
}

get_input () {
    [ -z "$1" ] && printf "Must include a message for the user. Exiting.\n" && exit 1
    local message=$1
    local -n ref=${2:?}
    local default_input=${3:-}
    while true
    do
        read -r -p "$message" input
        if [ -z "$input" ]; then input=$default_input; fi
        ref=$input
        export ref
        if get_confirmation "Is this correct: '$input'?"; then
            break
        fi
    done
}
