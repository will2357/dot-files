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
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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
alias ll='ls -alF --full-time'
alias la='ls -A'
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

# Lazy alias
alias cvim='ctags -R . && vim .'

# lazy function to unzip to folder of same name
unzipd () {
    zipfile="$1"
    zipdir=${1%%.*}
    unzip -d "$zipdir" "$zipfile"
}

# Should probably just do this manually... but...
recurse-replace () {
    old_val=$1
    new_val=$2
    if type ack > /dev/null; then
        color_normal=$(tput sgr0)
        color_blue=$(tput setaf 4)
        color_red=$(tput setaf 1)
        color_bold=$(tput bold)

        cmd="ack $old_val | grep -e '^\w' | cut -d: -f1 | xargs sed -i 's/$old_val/$new_val/g'"
        printf "%sAbout to run:\n%s" "$color_blue" "$color_normal"
        echo "${color_bold}$cmd${color_normal}"
        printf "\n%sThis will replace the following:\n%s" "$color_blue" "$color_normal"
        ack "$old_val"
        echo

        bold_message="${color_bold}Are you sure? (y/N)${color_normal}"
        read -r -p "$bold_message" yn
        case $yn in
            [Yy]* ) printf "\nRunning replace command.\n"; eval "$cmd"; return 0;;
            [Nn]* ) return 1;;
            * ) return 1;;
        esac
    else
        printf "%sERROR: 'ack' not found\n%s" "$color_red" "$color_normal"
    fi
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

if [ -d "/usr/local/android-studio/jbr/bin" ] ; then
    PATH="$PATH:/usr/local/android-studio/jbr/bin"
fi

if [ -d "/usr/local/go" ] ; then
    PATH="$PATH:/usr/local/go/bin"
    export GOROOT="/usr/local/go"
fi

if [ -d "$HOME/.rbenv/bin" ] ; then
    eval "$($HOME/.rbenv/bin/rbenv init - bash)"
fi

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    # Load pyenv-virtualenv automatically by adding
    eval "$(pyenv virtualenv-init -)"
fi

export DOCKER_HOST="unix:///run/user/1000/docker.sock"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$HOME/Android/Sdk"
