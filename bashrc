# shellcheck shell=bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
export COLORTERM=24bit

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
linux*)
    echo -en "\e]P0073642" #black
    echo -en "\e]P8002b36" #brblack
    echo -en "\e]P1dc322f" #red
    echo -en "\e]P9cb4b16" #brred
    echo -en "\e]P2859900" #green
    echo -en "\e]PA586e75" #brgreen
    echo -en "\e]P3b58900" #yellow
    echo -en "\e]PB657b83" #bryellow
    echo -en "\e]P4268bd2" #blue
    echo -en "\e]PC839496" #brblue
    echo -en "\e]P5d33682" #magenta
    echo -en "\e]PD6c71c4" #brmagenta
    echo -en "\e]P62aa198" #cyan
    echo -en "\e]PE93a1a1" #brcyan
    echo -en "\e]P7eee8d5" #white
    echo -en "\e]PFfdf6e3" #brwhite
    clear #for background artifacting
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [ -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
if [ "$(uname)" == "Linux" ]
then
  alias ll='ls -alF --full-time'
elif [ "$(uname)" == "Darwin" ]
then
  alias ll='ls -alFT'
fi
alias la='ls -A'
alias lv='ls -A | xargs printf "%s\n"'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f "$HOME/.bash_aliases" ] || [ -h "$HOME/.bash_aliases" ]
then
    source "$HOME/.bash_aliases"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#MacOS git completion and prompt
# curl -o ~/.git-completion.bash https://github.com/git/git/raw/master/contrib/completion/git-completion.bash
# curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
if [ "$(uname)" == "Darwin" ]; then
  if [ -f "$HOME/.git-completion.bash" ]; then # MacOS
    .  "$HOME/.git-completion.bash"
  fi
  if [ -f "$HOME/.git-prompt.sh" ]; then # MacOS
    .  "$HOME/.git-prompt.sh"
  fi
fi


# Command prompt options
# NB: Keep bash completion before this so that __git_ps1 is defined
if [ -f "$HOME/.bash_functions" ] || [ -h "$HOME/.bash_functions" ]
then
    source "$HOME/.bash_functions"
fi

# Additional env vars
if [ -f "$HOME/.awsenvvars.sh" ] || [ -h "$HOME/.awsenvvars.sh" ]
then
    source "$HOME/.awsenvvars.sh"
fi

# unzipd: Unzips a file into a directory with the same name.
unzipd () {
    zipfile="$1"
    zipdir=${1%%.*}
    unzip -d "$zipdir" "$zipfile"
}

# git-cleanup: Deletes local branches merged into master/main.
# Also prunes stale remote-tracking references when remotes exist.
# Use --aggressive to also delete non-merged branches with no unique patches.
# Asks for confirmation before performing any destructive actions.
git-cleanup() {
    local aggressive=0
    case "${1:-}" in
        "")
            ;;
        -a|--aggressive)
            aggressive=1
            ;;
        -h|--help)
            printf "Usage: git-cleanup [-a|--aggressive] [-h|--help]\n"
            printf "  -a, --aggressive  Also delete non-merged branches with no unique patches.\n"
            printf "  -h, --help        Show this help message.\n"
            return 0
            ;;
        *)
            printf "Error: Unknown option '%s'.\n" "$1" >&2
            printf "Usage: git-cleanup [-a|--aggressive] [-h|--help]\n" >&2
            return 1
            ;;
    esac

    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        printf "Error: Not inside a git repository.\n" >&2
        return 1
    fi

    local main_branch
    if git show-ref --verify --quiet refs/heads/main; then
        main_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
        main_branch="master"
    else
        printf "Error: Could not find 'main' or 'master' branch.\n" >&2
        return 1
    fi

    printf "Using '%s' as the primary branch.\n" "$main_branch"

    if [ -n "$(git remote)" ]; then
        if ! git fetch --prune; then
            printf "Error: Failed to prune remote-tracking references.\n" >&2
            return 1
        fi
        printf "Pruned remote-tracking references.\n"
    else
        printf "No remotes configured; skipping remote-tracking prune.\n"
    fi

    local current_branch
    current_branch=$(git branch --show-current)

    local merged_local=()
    local aggressive_local=()
    local branch
    local unique_patches

    while IFS= read -r branch; do
        [ -z "$branch" ] && continue
        case "$branch" in
            "$current_branch"|main|master)
                continue
                ;;
        esac
        merged_local+=("$branch")
    done < <(git for-each-ref refs/heads --merged "$main_branch" --format='%(refname:short)')

    if [ "$aggressive" -eq 1 ]; then
        while IFS= read -r branch; do
            [ -z "$branch" ] && continue
            case "$branch" in
                "$current_branch"|main|master)
                    continue
                    ;;
            esac
            if git merge-base --is-ancestor "$branch" "$main_branch"; then
                continue
            fi
            unique_patches=$(git log --cherry-pick --right-only --no-merges --pretty=format:%H "$main_branch...$branch")
            if [ -n "$unique_patches" ]; then
                continue
            fi
            aggressive_local+=("$branch")
        done < <(git for-each-ref refs/heads --format='%(refname:short)')
    fi

    if [ "${#merged_local[@]}" -eq 0 ] && [ "${#aggressive_local[@]}" -eq 0 ]; then
        printf "No local branches to clean up.\n"
        return 0
    fi

    if [ "${#merged_local[@]}" -ne 0 ]; then
        printf "\nThe following merged local branches will be deleted:\n"
        printf "%s\n" "${merged_local[@]}"
    fi

    if [ "${#aggressive_local[@]}" -ne 0 ]; then
        printf "\nAggressive mode: the following non-merged branches have no unique patches and will be deleted:\n"
        printf "%s\n" "${aggressive_local[@]}"
    fi

    local yn
    printf "\n"
    read -r -p "$(tput bold)Delete these local branches? (y/N) $(tput sgr0)" yn
    case $yn in
        [Yy]* )
            local delete_failed=0
            for branch in "${merged_local[@]}"; do
                if ! git branch -d "$branch"; then
                    delete_failed=1
                fi
            done
            for branch in "${aggressive_local[@]}"; do
                if ! git branch -D "$branch"; then
                    delete_failed=1
                fi
            done
            if [ "$delete_failed" -ne 0 ]; then
                printf "Cleanup completed with errors.\n" >&2
                return 1
            fi
            printf "Cleanup complete.\n"
            ;;
        * )
            printf "Cleanup aborted.\n"
            ;;
    esac
}

# av: Activates the Python virtual environment (.venv) created by 'uv'.
av() {
    local activate=".venv/bin/activate"
    if [ ! -f "$activate" ]; then
        printf "%sError: '%s' not found. Did you run 'uv sync'?%s\n" \
            "$(tput setaf 1)" "$activate" "$(tput sgr0)" >&2
        return 1
    fi
    source "$activate"
    printf "%sActivated %s.%s\n" \
        "$(tput setaf 2)" "$activate" "$(tput sgr0)"
}

# recurse-replace: Performs a global search and replace in the current directory using 'ack'.
# Usage: recurse-replace <old_string> <new_string>
recurse-replace () {
    local old_val=${1:-}
    local new_val=${2:-}
    local color_normal color_blue color_red color_bold
    color_normal=$(tput sgr0)
    color_blue=$(tput setaf 4)
    color_red=$(tput setaf 1)
    color_bold=$(tput bold)

    if [ -z "$old_val" ] || [ -z "$new_val" ]; then
        printf "%sUsage: recurse-replace <old_string> <new_string>%s\n" \
            "$color_red" "$color_normal" >&2
        return 1
    fi

    if ! command -v ack >/dev/null 2>&1; then
        printf "%sERROR: 'ack' not found%s\n" "$color_red" "$color_normal" >&2
        return 1
    fi

    local -a files=()
    local file
    while IFS= read -r file; do
        [ -n "$file" ] && files+=("$file")
    done < <(ack -l -- "$old_val")

    if [ "${#files[@]}" -eq 0 ]; then
        printf "%sNo matches found for '%s'.%s\n" \
            "$color_blue" "$old_val" "$color_normal"
        return 0
    fi

    printf "%sAbout to replace '%s' with '%s' in:%s\n" \
        "$color_blue" "$old_val" "$new_val" "$color_normal"
    printf "%s\n" "${files[@]}"
    printf "\n%sMatching lines:%s\n" "$color_blue" "$color_normal"
    ack -- "$old_val"
    echo

    local yn
    local bold_message="${color_bold}Are you sure? (y/N)${color_normal}"
    read -r -p "$bold_message" yn
    case $yn in
        [Yy]* )
            printf "\nRunning replace command.\n"
            for file in "${files[@]}"; do
                OLD_VAL="$old_val" NEW_VAL="$new_val" \
                    perl -pi -e 's/\Q$ENV{OLD_VAL}\E/\Q$ENV{NEW_VAL}\E/g' -- "$file"
            done
            return 0
            ;;
        * )
            return 1
            ;;
    esac
}

alias speed-test='curl -s \
    https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
    | python -'

# Add local executables to PATH
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi

if [ -d "$HOME/go" ] ; then
    PATH="$PATH:$HOME/go/bin"
    export GOPATH="$HOME/go"
fi

# Add bin for flutter to PATH
if [ -d "$HOME/.pub-cache/bin" ]; then
    PATH="$PATH":"$HOME/.pub-cache/bin"
fi

if [ -d "/usr/local/android-studio/jbr" ] ; then
    export JAVA_HOME="/usr/local/android-studio/jbr"
    PATH="$PATH:$JAVA_HOME/bin"
fi

if [ -d "/usr/local/go" ] ; then
    PATH="$PATH:/usr/local/go/bin"
    export GOROOT="/usr/local/go"
fi

if ! type rbenv >&/dev/null && [ -d "$HOME/.rbenv/bin" ] ; then
    # shellcheck disable=SC2086
    eval "$("$HOME"/.rbenv/bin/rbenv init - bash)"
fi

if ! type nvm >&/dev/null && [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d "$HOME/Android/Sdk" ] ; then
    export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
    export ANDROID_HOME="$HOME/Android/Sdk"
    PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
fi

if [ -d "$HOME/.opencode/bin" ]; then
    export PATH="$HOME/.opencode/bin:$PATH"
fi

if [ -d "$HOME/.aws" ]; then
    [ -n "${AWS_REGION:-}" ] || export AWS_REGION="us-east-1"
    [ -n "${AWS_DEFAULT_REGION:-}" ] || export AWS_DEFAULT_REGION="us-east-1"
fi

if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion bash)"
fi

if command -v eksctl >/dev/null 2>&1; then
    # shellcheck disable=SC1090
    . <(eksctl completion bash)
fi

if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi


# Added by Antigravity CLI installer
export PATH="/home/will/.local/bin:$PATH"
