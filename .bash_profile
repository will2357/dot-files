# Heroku App Shortcuts
export P='--app adaptly-production'
export S='--app adaptly-showtime'
export T='--app adaptly-test'
export SH='--app adaptly-staging-hot'
export FC='--app adaptly-flying-circus'
export ST='--app adaptly-staging'
export H='--app adaptly-hubot'
export J='--app adaptly-janky'
export M='--app adaptly-media-live'
export FS='--app facebook-stats'
export L='--app adaptly-live'
export I='--app adaptly-insightful'
export AH='--app admin-hot'
export FM='--app facebook-mirror'
export FMS='--app facebook-mirror-staging'
export BA='--app facebook-budget-allocation'
export CG='--app campaign-grouper'
export SS='--app adaptly-self-serve'
export AE='--app adaptly-edge'
export AE2='--app adaptly-edge-2'
export ES='--app ending-system'
export CGT='--app wh-temp-cg-checker'

export PRIVATE_KEY_PATH='~/.ssh/id_rsa'
export PUBLIC_KEY_PATH='~/.ssh/id_rsa.pub'

export LEIN_FAST_TRAMPOLINE=1

export CLICOLOR=1
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export ARCHFLAGS="-arch x86_64"
export CC=gcc-4.2
export PATH=$PATH:~/bin
export PATH=$PATH:/usr/local/sbin
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:~/storm/bin
export PATH=$PATH:/Users/will/.local/lib/aws/bin

export CTAGS=--langmap=lisp:+.clj

export DATABASE_READ_SLAVE_URL=postgres://u8ms5hp1ate84n:pm4j8ioaalone6glgaopbsd3dj@ec2-107-20-228-35.compute-1.amazonaws.com:5432/d6lh77ect576md

if [[ `uname` == 'Darwin' ]]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
fi


##
# Your previous /Users/will/.bash_profile file was backed up as /Users/will/.bash_profile.macports-saved_2012-12-07_at_19:44:59
##

# MacPorts Installer addition on 2012-12-07_at_19:44:59: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

if [ -f ~/.cg-aggregator-credentials ]; then
  . ~/.cg-aggregator-credentials
fi

source ~/.bashrc

##
# Your previous /Users/will/.bash_profile file was backed up as /Users/will/.bash_profile.macports-saved_2014-02-14_at_16:14:22
##

# MacPorts Installer addition on 2014-02-14_at_16:14:22: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/will/.bash_profile file was backed up as /Users/will/.bash_profile.macports-saved_2014-02-14_at_16:50:53
##

# MacPorts Installer addition on 2014-02-14_at_16:50:53: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

