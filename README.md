will2357's Dot Files
============

## Configuration Files

The following configuration files are included:
* ackrc
* bash_functions
* bashrc
* ctags
* gitignore
* gitignore_global
* gitmodules
* irbc
* pryrc
* pythonrc
* railsrc
* tmux.conf
* vimrc

## Installation

A `dot_install.sh` shell script is included to create symbolic links in the
user's `$HOME` directory.

Backups will be made as follows:
```
$HOME/.filename -> $HOME/filename.BAK
```

Only tested on linux.

### To use:
```
chmod +x dot_install.sh
./dot_install.sh
```
Follow the on-screen prompts.

### For help and additional options:
```
./dot_install.sh -h
```

**NB: Highly recommended to do a dry run first:**
```
./dot_install.sh -d
```
