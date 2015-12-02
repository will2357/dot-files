# Save history across the board:
# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups
# append history entries..
shopt -s histappend

export PATH=~/.local/bin:$PATH

source /usr/local/bin/virtualenvwrapper.sh
# After each command, save and reload history
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

alias lmf="(lein midje 2>&1) | grep -E 'FAIL'"

complete -C aws_completer aws

alias emr-new="/Users/will/emr-new/elastic-mapreduce"
alias emr-old="/Users/will/emr-old/elastic-mapreduce"
# OS Specific Configuration
if [[ `uname` == 'Linux' ]]; then
  alias top="top"
elif [[ `uname` == 'Darwin' ]]; then
  alias top="top -o rsize  -O cpu"
  alias octave="exec '/Applications/Octave.app/Contents/Resources/bin/octave'"

  #if [ -f `brew --prefix`/etc/bash_completion ]; then
    #. `brew --prefix`/etc/bash_completion
  #fi

  #if [ -f /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh ]; then
    #. /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh
  #fi

  # MacPorts Installer addition on 2011-12-20_at_10:51:00: adding an appropriate PATH variable for use with MacPorts.
  export PATH=/opt/local/bin:/opt/local/sbin:$PATH

  # Setting PATH for Python 2.7
  # The orginal version is saved in .bash_profile.pysave
  PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
  export PATH

  export CLASSPATH="/Library/Java/Extensions/pg73jdbc2ee.jar:."
  export PYTHONPATH=/Users/will/adaptly/:$PYTHONPATH
  export PYTHONPATH=/Users/will/adaptly/flying_circus:$PYTHONPATH

else
  echo "Platform unknown. ~/.bashrc only configured for Linux and Darwin. Try running 'uname'"
fi

# Alias for ctags before vim
if hash ctags 2>/dev/null; then alias cvim="ctags -R .; vim .";fi


alias hu="heroku"
# favorite default run options
alias tmux="TERM=screen-256color-bce tmux"

# grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git alias for commits vs origin/master
alias gitc="git cherry -v origin/master | wc -l"

# Kill adaptly_development db
alias killdb="ps ax | grep adaptly_development | grep -Ev 'tmux|grep' | awk '{print $1}' | xargs kill"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

export PYTHONSTARTUP=~/.pythonrc

shopt -s cdspell

export PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin

export WORKON_HOME=$HOME/.virtualenvs

export EDITOR="vim"
export ENABLE_ACTION_SPEC=TRUE

[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator_completion ]] && source $HOME/.tmuxinator/scripts/tmuxinator_completion

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Android Developer Tools
alias adt='~/bin/adt-bundle-mac/eclipse/Eclipse.app/Contents/MacOS/eclipse'

# capistrano with bundler
alias cap='bundle exec cap'

alias be='bundle exec'

alias cvim='ctags -R .; vim .'

# Amazon Elastic MapReduce
#alias emr='/usr/bin/ruby ~/bin/elastic-mapreduce-ruby/elastic-mapreduce'
#alias emr-last="emr --ssh -- jobflow `emr --list | ack WAITING | awk '{print $1}'`"

# Local Hadoop Config
export JAVA_HOME="$(/usr/libexec/java_home)"
alias hadoop-start='/usr/local/Cellar/hadoop/1.1.1/libexec/bin/start-all.sh'
alias hadoop-stop='/usr/local/Cellar/hadoop/1.1.1/libexec/bin/stop-all.sh'

# Local Hive Config
export HIVE_HOME=/usr/local/Cellar/hive/0.9.0/libexec

#JGit for S3 Repos
alias jgit='~/bin/org.eclipse.jgit.pgm-2.1.0.201209190230-r.sh'

# s3cmd to sync local folder to master of git.repos bucket
alias s3cmd-sync="s3cmd sync . s3://git.repos/${PWD##*/}/master/"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Vertica client
export PATH="/Users/will/vertica/bin:$PATH"
source ~/.git-prompt.sh
[[ -f ~/.bash_functions ]] && . ~/.bash_functions
#export GIT_PS1_SHOWCOLORHINTS=true
#export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
#export PROMPT_COMMAND='$PS1'
#export PROMPT_COMMAND='PS1="[\u@\h \W$(__git_ps1 " (%s)")]\$ "'
#export PROMPT_COMMAND='PS1="$(set_ps1)"'
#`eval "$(boot2docker shellinit)"`
