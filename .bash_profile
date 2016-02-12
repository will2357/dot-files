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

export PRIVATE_KEY_PATH='~/.ssh/id_rsa'
export PUBLIC_KEY_PATH='~/.ssh/id_rsa.pub'

# Android Studio pre v1.1
export STUDIO_JDK='/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk'

export CLICOLOR=1
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export ARCHFLAGS="-arch x86_64"
export CC=gcc-4.2
export PATH=$PATH:~/bin
export PATH=$PATH:/usr/local/sbin
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:~/storm/bin
export PATH=$PATH:/Users/will/.local/lib/aws/bin
export PATH=$PATH:/Users/will/activator

export CTAGS=--langmap=lisp:+.clj

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
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

if [ -e ~/.lein/bash_completion.bash ]; then
  . ~/.lein/bash_completion.bash
fi

if [ -f ~/.aws-credentials ]; then
  . ~/.aws-credentials
fi

if [ -f ~/.twitter-credentials.sh ]; then
  . ~/.twitter-credentials.sh
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
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



export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH

##
# Your previous /Users/will/.bash_profile file was backed up as /Users/will/.bash_profile.macports-saved_2015-12-28_at_10:34:16
##

# MacPorts Installer addition on 2015-12-28_at_10:34:16: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

