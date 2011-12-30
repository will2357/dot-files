#!/bin/bash

color_normal=$(tput sgr0)

prn_error () {
    error_message=$1
    color_red=$(tput setaf 1)
    printf "\n%s\n" "${color_red}$error_message${color_normal}"
}

prn_success () {
    success_message=$1
    color_green=$(tput setaf 2)
    printf "\n%s\n" "${color_green}$success_message${color_normal}"
}

prn_note () {
    color_blue=$(tput setaf 4)
    note_message=$1
    printf "\n%s\n" "${color_blue}$note_message${color_normal}"
}

get_confirmation () {
    [ -z "$1" ] && prn_error "Must include a message for the user. Exiting." && exit 1
    message=$1
    bold_message="$(tput bold)$message (yes/No) ${color_normal}"

    read -r -p "$bold_message" yn
    case $yn in
        [Yy]* ) printf "Response: %s\n" "$yn"; return 0;;
        [Nn]* ) return 1;;
        * ) return 1;;
    esac
}

get_input () {
    [ -z "$1" ] && printf "Must include a message for the user. Exiting.\n" && exit 1
    message=$1
    local -n ref=$2
    default_input=$3
    while true
    do
        read -r -p "$message" input
        if [ -z "$input" ]; then input=$default_input; fi
        ref=$input
        resp=$(get_confirmation "Is this correct: '$input'?")
        if [ -n "$resp" ]
        then
            break
        fi
    done
}
