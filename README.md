will2357's Ubuntu Clean Install Setup and Dot Files Scripts
============

## Information

A `clean_install.sh` script to install some basic packages via `apt`,
Google Chrome web browser from the latest `deb`, configure git, compile vim from
source (with clipboard options), compile neovim from source, and setup dot files
(using the standalone `dot_install.sh` script below) with plugin installation
for `vim` and `tmux`.

A `dot_install.sh` shell script is included to create symbolic links in the
user's `$HOME` directory. Makes backups will as follows:
```
$HOME/.filename -> $HOME/.filename.BAK
```

Tested on Ubuntu 22.04, 24.04, and 26.04 LTS Desktop (fully updated, minimal install).

The following configuration files are included:
* ackrc*
* bash_functions*
* bashrc*
* config/nvim/init.vim*
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
Tested on clean installs of Ubuntu 22.04, 24.04, and 26.04 LTS (Desktop and Server)
with minimal install and no additional packages.

Clone this repo and run `./clean_install.sh`.

Alternatively, download the compressed repo from github and run the script:

```
wget https://github.com/will2357/dot-files/archive/refs/heads/master.tar.gz
tar xvf master.tar.gz
cd dot-files-master
chmod +x clean_install.sh
./clean_install.sh
```
Note the above will also call the `dot_install.sh` configuration script, which can
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

This project uses [bats-core](https://github.com/bats-core/bats-core) for testing.

#### Running Tests Locally

```bash
# Install dependencies
apt install bats shellcheck  # or: brew install bats-core

# Syntax checks only (fast - ~5 seconds)
make syntax

# Unit tests (~30 seconds)
make unit

# Integration tests in Docker (~30 minutes)
make integration

# Run all tests (syntax + unit)
make test

# Run all tests including integration
make all

# Show help
make help
```

#### Test Types

| Command | Description | Runtime |
|---------|-------------|---------|
| `make syntax` | shellcheck + bash -n on all scripts | ~15 sec |
| `make unit` | bats-core unit tests for functions/logic | ~15 sec |
| `make integration` | Full clean_install.sh in Docker (22.04 + 24.04 + 26.04) | ~6 min |
| `make test` | Runs syntax + unit tests | ~30 sec |
| `make all` | Runs syntax + unit + integration tests | ~6 min |

#### CI

Tests run automatically on GitHub Actions:
- **syntax**: Every push/PR to main
- **unit**: Every push/PR to main
- **integration**: Every push/PR to main + weekly schedule

#### Dependencies for Testing

- `bash` - Shell interpreter
- `bats-core` - Bash automated testing framework
- `shellcheck` - Static analysis for shell scripts
- `docker` - For integration tests
