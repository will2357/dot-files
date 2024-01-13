#!/bin/bash

if [ ! "$(uname)" == "Linux" ]; then echo "Must be on a debian based Linux system."; exit 1; fi

curr_dir=$PWD
home_dir=$HOME
temp_dir=/tmp/tmp_install

# Switch to tmp dir
if pwd | grep -q /tmp_install$ ;then
    printf "Already in a tmp_install directory.\n\n"
    temp_dir="$curr_dir"
else
    mkdir -p "$temp_dir"
    cd "$temp_dir" || exit 1
fi

# Get latest package lists
sudo apt-get update

# Don't bother with silly legal agreements on ubuntu-restricted-extras
export DEBIAN_FRONTEND=noninteractive
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
# Install basic requirements via apt
sudo apt install -y autoconf \
    build-essential \
    exuberant-ctags \
    curl  \
    git  \
    gh \
    htop \
    libcurl3-gnutls \
    libcurl4-openssl-dev \
    libncurses5-dev \
    libreadline6-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    python3-dev \
    shellcheck \
    ssh \
    tmux  \
    ubuntu-restricted-addons \
    ubuntu-restricted-extras \
    zlib1g \
    zlib1g-dev

printf "\n\n\nInstalled basic packages via apt.\n"

printf "\n\n\nInstalling rbenv via rbenv-installer script.\n"
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Install thorium browser
if [ -z "$(which thorium-browser)" ]; then
    thorium_deb=$(curl -s https://api.github.com/repos/Alex313031/Thorium/releases/latest | grep "browser_download_url.*amd64\.deb" | awk '{print $2}' | tr -d \")
    wget "$thorium_deb"
    sudo dpkg -i thorium-browser*amd64.deb
else
    printf "\n\n\nthorium-browser already installed. Skipping.\n"
fi


printf "\n\n\nConfiguring git...\n"
git config --global user.name "will2357"
git config --global user.email "will.highducheck@gmail.com"
git config --global push.default simple
git config --global core.excludesfile "$home_dir/.gitignore_global"
git config --global core.editor vim
git config --global merge.tool vim
gh auth login

src_dir="$home_dir/src"
printf "Changing directory to '%s'" "$src_dir"
mkdir -p "$src_dir"
cd "$src_dir" || exit 1

printf "\nCompiling vim from source.\n"
sudo apt purge -y vim
sudo rm -rf vim
git clone https://github.com/vim/vim.git
cd vim/src/ || exit 1
sudo sed -i 's/\#\ deb\-src/deb-src/g' /etc/apt/sources.list
sudo apt update
sudo apt build-dep -y vim-gtk vim-gtk3
sudo ./configure --with-features=huge --enable-multibyte \
    --enable-rubyinterp=yes --enable-python3interp=yes \
    --with-python3-config-dir="$(python3-config --configdir)" \
    --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 \
    --enable-cscope --enable-gui --with-x
sudo make
sudo make install
printf "\nFinished compiling vim from source.\n\n"

cd "$src_dir" || exit 1

if [ ! -d "$src_dir/dot_files" ]; then
    git clone https://github.com/will2357/dot_files.git "$src_dir/dot_files"
fi
cd dot_files || exit 1
if [ "$(git branch -l | grep linux | awk '{print $2}')" ]; then
    printf "\n\n\nUsing linux branch in dot_files repo.\n"
    git checkout linux
else
    printf "\n\n\nNo branch named linux in dot_files repo. Using master.\n"
fi

printf "\n\n\nRunning 'dot_install.sh' script with default options.\n"

chmod +wrx dot_install.sh
./dot_install.sh
cd "$curr_dir" || exit 1

vim_plug="$home_dir/.vim/autoload/plug.vim"
if [ ! -f "$vim_plug" ]; then
    printf "\n\n\nInstalling vim-plug.\n"
    curl -fLo "$vim_plug" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim_solar_dir="$home_dir/.vim/bundle/vim-colors-solarized"
if [ ! -d "$vim_solar_dir" ]; then
    #$home_dir/.vim/bundle/vim-colors-solarized
    git clone https://github.com/altercation/vim-colors-solarized.git "$vim_solar_dir"
fi
vim +'PlugInstall --sync' +qa

tmux_plugin_man_dir="$home_dir/.tmux/plugins/tpm"
if [ ! -d "$tmux_plugin_man_dir" ];then
    printf "\n\n\nInstalling tpm for tmux.\n"
    git clone https://github.com/tmux-plugins/tpm "$tmux_plugin_man_dir"
    # start a server but don't attach to it
    tmux start-server
    # create a new session but don't attach to it either
    tmux new-session -d
    # install the plugins
    "$tmux_plugin_man_dir/scripts/install_plugins.sh"
fi

echo
printf  '\e[1;32m%-6s\e[m' "Successfully ran 'clean_install.sh'."
echo
echo
printf '\e[1;31m%-6s\e[m' "NOTE:
Change terminal colors to solarized dark by going to the GNOME terminal menu ->
'Preferences' -> 'Profiles|Unnamed' -> 'Colors' ->
Uncheck 'Use colors from system theme'
Select 'Solarized dark' from 'Built-in schemes' in both 'Text and Background' and 'Palette'"
echo
echo
exit 0
