will2357's Ubuntu Clean Install Setup and Dot Files Scripts
============

## Information

A `clean_install.sh` script to install some basic packages via `apt`,
Thorium web browser from the latest `deb`, configure git, compile vim from
source (with clipboard options), and setup dot files (using the standalone
`dot_files.sh` script below) with plugin installation for `vim` and `tmux`.

A `dot_install.sh` shell script is included to create symbolic links in the
user's `$HOME` directory. Makes backups will as follows:
```
$HOME/.filename -> $HOME/filename.BAK
```

Only tested on Ubuntu 22.04.3 LTS Desktop fully updated, minimal install.

The following configuration files are included:
* ackrc*
* bash_functions*
* bashrc*
* ctags*
* ctags.d/scala.ctags*
* ctags.d/tsx.ctags*
* gitignore_global*
* irbc
* pryrc
* pythonrc
* railsrc
* shellcheckrc
* tmux.conf*
* vimrc*

_* Installed by default_

### Usage
#### Full Install
Tested on a clean install of Ubuntu 22.04.3 LTS Desktop and Server editions
minimal install with no additional packages.

```
wget https://github.com/will2357/dot_files/archive/refs/heads/master.tar.gz
tar xvf master.tar.gz
cd dot_files-master
chmod +x clean_install.sh
./clean_install.sh
```
Note the above will also call the `dot_files.sh` configuration script, which can
be declined via the script's prompts.


#### Dot File Only Install
```
chmod +x dot_install.sh
./dot_install.sh
```
Follow the on-screen prompts.

##### For help and additional options (dot_install.sh only):
```
./dot_install.sh -h
```

**NB: Highly recommended to do a dry run first:**
```
./dot_install.sh -d
```

### Testing
Currently, only tested via `shellcheck`:
```
shellcheck _shared_functions.sh dot_install.sh clean_install.sh
```

TODO: Add unit tests via either [bats-core](https://github.com/bats-core/bats-core) or [shunit2](https://github.com/kward/shunit2).

Why? Because tests are awesome, and I've never written tests for shell scripts.
