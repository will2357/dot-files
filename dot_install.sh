#!/bin/bash

dry_run='false'
files=''
file_array=()
default_file_array=(
    'vimrc'
    'tmux.conf'
    'bashrc'
)

print_options () {
  printf "Options:\n"
  printf "  -d Dry run\n"
  printf "  -f List of files to link\n"
  printf "  -h This help screen\n"
}

while getopts 'dhf:' opt
do
  case "${opt}" in
    d) dry_run='true' ;;
    h) print_options ; exit 0 ;;
    f) files+="${OPTARG}" ;;
    *) print_options; exit 1 ;;
  esac
done


shift $(( OPTIND - 1 ));
echo "@: $@"
additional_files=$@
files+=" $additional_files"
file_array=( $files )

[ "$dry_run" = 'true' ] && printf "\n\n\n!!!DRY RUN!!!\n!!!DRY RUN!!!\n!!!DRY RUN!!!\n\n\n"


curr_dir=$PWD
echo
echo "curr directory: $curr_dir"

targ_dir=$HOME
echo "home directory: $targ_dir"
echo

get_input () {
    [ -z "$1" ] && printf "Must include a message for the user. Exiting.\n" && exit 1
    message=$1
    while true
    do
        read -r -p "$message" yn
        case $yn in
            [Yy]* ) echo $yn; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}


link_file_with_backup () {
    filename=$1
    printf 'Processing %s...\n' "$filename"

    cp_cmd="cp $targ_dir/.$filename $targ_dir/$filename.BAK"
    printf 'Running "%s"\n' "$cp_cmd"
    [ "$dry_run" = 'false' ] && eval "$cp_cmd"
    printf "Done.\n"

    ln_cmd="ln -sf $curr_dir/$filename $targ_dir/.$filename"
    printf 'Running "%s"\n' "$ln_cmd"
    [ "$dry_run" = 'false' ] && eval "$ln_cmd"
    printf "Done.\n"
    echo
}

check_files_exist () {
    for file in "${file_array[@]}"
    do
        file_with_path=$curr_dir/${file#.}
        printf "Checking '%s'\n" $file_with_path
        if [ -f $file_with_path ]; then
            printf "File exists.\n"
        else
            printf "ERROR: File '%s' does not exist. Exiting.\n" $file_with_path
            exit 1
        fi
    done
    printf "Done.\n"
}

link_dot_files () {
    if [ ! -d "$curr_dir/.git" ]
    then
        echo "ERROR: Not in git repo directory. Exiting."
        exit 1
    fi

    echo
    printf "Linking dot files by 'ln -sf %s/filename %s/.filename'\n" "$curr_dir" "$targ_dir"
    printf 'Backups will be made as follows: %s/.filename -> %s/filename.BAK\n' "$targ_dir" "$targ_dir"
    echo


    if [ ${#file_array[@]} -eq 0  ]
    then
        file_array=("${default_file_array[@]}")
        files="${file_array[@]}"
    fi

    printf 'List of %d files to process: %s\n' "${#file_array[@]}" "$files"
    echo
    get_input "Is this the correct list of files (yes/no)? "

    check_files_exist

    for file in "${file_array[@]}"
    do
        clean_name="${file#.}"
        link_file_with_backup $clean_name
    done
    #link_file_with_backup 'tmux.conf'
    #ln -sf $PWD/.ackrc                                 $HOME/.ackrc
    #ln -sf $PWD/.bash_functions                        $HOME/.bash_functions
    #ln -sf $PWD/.bash_profile                          $HOME/.bash_profile
    #ln -sf $PWD/.bashrc                                $HOME/.bashrc
    #ln -sf $PWD/.ctags                                 $HOME/.ctags
    #ln -sf $PWD/.git-prompt.sh                         $HOME/.git-prompt.sh
    #ln -sf $PWD/.gitignore                             $HOME/.gitignore
    #ln -sf $PWD/.gitignore_global                      $HOME/.gitignore_global
    #ln -sf $PWD/.gitmodules                            $HOME/.gitmodules
    #ln -sf $PWD/.irbrc                                 $HOME/.irbrc
    #ln -sf $PWD/.midje.clj                             $HOME/.midje.clj
    #ln -sf $PWD/.pryrc                                 $HOME/.pryrc
    #ln -sf $PWD/.pythonrc                              $HOME/.pythonrc
    #ln -sf $PWD/.railsrc                               $HOME/.railsrc
    #ln -sf $PWD/.tmux.conf                             $HOME/.tmux.conf
    #ln -sf $PWD/.vimrc                                 $HOME/.vimrc
}

answer=$(get_input "Do you wish to link your dot files to your home directory (yes/no)? ")
[ ! -z $answer ] && link_dot_files

exit 0
