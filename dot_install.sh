#!/bin/bash

source "_shared_functions.sh"

dry_run='false'
user_files='false'
file_names=''
file_array=()
default_file_array=(
    'vimrc'
    'tmux.conf'
    'bashrc'
    'bash_functions'
    'gitignore_global'
)

print_options () {
  printf "Options:\n"
  printf "  -d Dry run\n"
  printf "  -f Space separated list of files to link\n"
  printf "  -h This help screen\n"
}

while getopts 'dhf:' opt
do
  case "${opt}" in
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

curr_dir=$PWD
echo
echo "curr directory: $curr_dir"

targ_dir=$HOME
echo "home directory: $targ_dir"
echo

link_file_with_backup () {
    filename=$1
    prn_note "Processing '$filename'... "

    mv_cmd="mv $targ_dir/.$filename $targ_dir/$filename.BAK"
    printf "Running '%s'\n" "$mv_cmd"
    [ "$dry_run" = 'false' ] && eval "$mv_cmd"
    printf "Done.\n"

    ln_cmd="ln -sf $curr_dir/$filename $targ_dir/.$filename"
    printf "Running '%s'\n" "$ln_cmd"
    [ "$dry_run" = 'false' ] && eval "$ln_cmd"
    printf "Done.\n"
    echo
}

check_files_exist () {
    for file in "${file_array[@]}"
    do
        file_with_path="$curr_dir/${file#.}"
        printf "\nChecking '%s'\n" "$file_with_path"
        if [ -f "$file_with_path" ]; then
            printf "File exists.\n"
        else
            missing_file_message="ERROR: File '$file_with_path' does not exist. Exiting."
            prn_error "$missing_file_message"
            exit 1
        fi
    done
    printf "Done.\n\n"
}

link_dot_files () {
    printf "\nLinking dot files by 'ln -sf %s/filename %s/.filename'\n" "$curr_dir" "$targ_dir"
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
        clean_name="${file#.}"
        link_file_with_backup "$clean_name"
    done
}

resp=$(get_confirmation "Do you wish to link your dot files to your home directory?")
if [ -n "$resp" ]
then
    link_dot_files
    prn_success "SUCCESS: Ran 'dot_install.sh' script without errors."
fi

exit 0
