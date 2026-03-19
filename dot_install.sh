#!/bin/bash

set -eu

script_dir="$(dirname "$(readlink -f "$0")")"
source "$script_dir/_shared_functions.sh"

dotfiles_dir="$script_dir/dotfiles"

# Global configuration flags - intentionally global for function access
# These are set from CLI arguments and read by helper functions
dry_run='false'
user_files='false'
file_names=''
copy_files='false'
file_array=()
default_file_array=(
    'dotfiles/ackrc'
    'dotfiles/bash_functions'
    'dotfiles/bashrc'
    'config/nvim/init.vim'
    'dotfiles/ctags'
    'dotfiles/ctags.d/scala.ctags'
    'dotfiles/ctags.d/tsx.ctags'
    'dotfiles/gitignore_global'
    'dotfiles/tmux.conf'
    'dotfiles/vimrc'
)

print_options () {
  printf "Options:\n"
  printf "  -c Copy files instead of creating symbolic links\n"
  printf "  -d Dry run\n"
  printf "  -f Space separated list of files to link\n"
  printf "  -h This help screen\n"
}

while getopts 'cdhf:' opt
do
  case "${opt}" in
    c) copy_files='true' ;;
    d) dry_run='true' ;;
    h) print_options ; exit 0 ;;
    f) user_files='true' ; file_names+="${OPTARG}" ;;
    *) print_options ; exit 1 ;;
  esac
done

shift $(( OPTIND - 1 ));
additional_files=("$@")
file_array+=("$file_names")
file_array+=("${additional_files[@]}")
file_names+=" ${additional_files[*]}"

[ "$dry_run" = 'true' ] && printf "\n\n\n!!!DRY RUN!!!\n!!!DRY RUN!!!\n!!!DRY RUN!!!\n\n\n"

targ_dir=$HOME
printf "$(tput bold)\nScript source directory:\t'%s'\n" "$script_dir"
printf "Target destination directory:\t'%s'\n${color_normal}" "$targ_dir"

link_file_with_backup () {
    local file_path=$1
    local filename="${file_path##*/}"
    if [[ "$file_path" == */* ]]; then
        local source_file="$script_dir/$file_path"
        local path_dir="$targ_dir/.${file_path%/*}"
        local path_filename="$path_dir/$filename"
    else
        local source_file="$dotfiles_dir/$file_path"
        local path_filename="$targ_dir/.$filename"
    fi
    local backup="$path_filename.BAK"
    prn_note "Processing '$filename'... "

    if [ -h "$path_filename" ]; then
        printf "Running 'cp %s %s'\n" "$(readlink "$path_filename")" "$backup"
        [ "$dry_run" = 'false' ] && cp "$(readlink "$path_filename")" "$backup"
    elif [ -f "$path_filename" ]; then
        printf "Running 'cp %s %s'\n" "$path_filename" "$backup"
        [ "$dry_run" = 'false' ] && cp "$path_filename" "$backup"
    fi
    printf "Done.\n"

    if [[ "$path_filename" == */* ]]; then
        mkdir -p "${path_filename%/*}"
    fi

    if [ "$copy_files" = 'true' ]; then
        printf "Running 'rm -f %s && cp %s %s'\n" "$path_filename" "$source_file" "$path_filename"
        [ "$dry_run" = 'false' ] && rm -f "$path_filename" && cp "$source_file" "$path_filename"
    else
        printf "Running 'ln -sf %s %s'\n" "$source_file" "$path_filename"
        [ "$dry_run" = 'false' ] && ln -sf "$source_file" "$path_filename"
    fi
    printf "Done.\n"
    echo
}

check_files_exist () {
    for file in "${file_array[@]}"
    do
        if [[ "$file" == */* ]]; then
            local source_path="$script_dir/$file"
        else
            local source_path="$dotfiles_dir/$file"
        fi
        printf "\nChecking '%s'\n" "$source_path"
        if [ -f "$source_path" ]; then
            printf "File exists.\n"
        else
            local missing_file_message="ERROR: File '$source_path' does not exist. Exiting."
            prn_error "$missing_file_message"
            exit 1
        fi
    done
    printf "Done.\n\n"
}

link_dot_files () {
    printf "\nLinking dot files by 'ln -sf %s/filename %s/.filename'\n" "$script_dir" "$targ_dir"
    printf 'Backups will be made as follows: %s/.filename -> %s/filename.BAK\n\n' "$targ_dir" "$targ_dir"

    if [ "$user_files" = 'false' ]
    then
        printf "No files specified with '-f SPACE SEPARATED LIST OF FILENAMES'.\n"
        printf "Using default list.\n\n"

        file_array=("${default_file_array[@]}")
        file_names="${file_array[*]}"
    fi

    printf "List of %d files to process: %s\n" "${#file_array[@]}" "$file_names"
    resp=$(get_confirmation "Is this the correct list of files?")

    if [ -n "$resp" ]
    then
        check_files_exist
    else
        exit 1
    fi

    for file in "${file_array[@]}"
    do
        link_file_with_backup "$file"
    done
}

resp=$(get_confirmation "Do you wish to link your dot files to these directories?")

if [ "$copy_files" == 'false' ]
then
    copy_resp=$(get_confirmation "Would you like to copy the files instead of creating symbolic links?")
    if [ -n "$copy_resp" ]
    then
        copy_files='true'
    fi
fi

if [ -n "$resp" ]
then
    link_dot_files
    prn_success "SUCCESS: Ran 'dot_install.sh' script without errors."
fi

exit 0
