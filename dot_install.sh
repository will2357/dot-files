#!/bin/bash

curr_dir=$PWD
echo
echo "curr directory: $curr_dir"

targ_dir=$HOME
echo "home directory: $targ_dir"
echo


link_file_with_backup () {
    echo $1

}

link_dot_files () {
    echo
    printf 'Linking dot files (ln -sf %s/filename %s/.filename)\n' "$curr_dir" "$targ_dir"
    printf 'Backups will be made as follows: %s/.filename %s/filename.BAK\n' "$targ_dir" "$targ_dir"
    link_file_with_backup 'vimrc'
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
    #mkdir -p $HOME/.vim/
    #ln -sf $PWD/.vim/                                  $HOME/.vim/
    #ln -sf $PWD/.vimrc                                 $HOME/.vimrc
    #mkdir -p $HOME/gnome-terminal-colors-solarized/
    #ln -sf $PWD/gnome-terminal-colors-solarized/       $HOME/gnome-terminal-colors-solarized/
}



while true; do
    read -r -p "Do you wish to link your dot files to your home directory (yes/no)? " yn
    case $yn in
        [Yy]* ) link_dot_files; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done



