#!/bin/sh

cp -rf vim $HOME/.vim
cp -rf vimrc $HOME/.vimrc
cp -rf vimrc.custom.config $HOME/.vimrc.custom.config

sudo apt update
sudo apt install cscope universal-ctags
sudo apt install vim-python*

# open vim and input :PlugInstall
# Enter .vim/Plug/YouCompileMe and execute git submodule update --recursive --remote and ./install.sh --clang-completer
# OK YCM fine.

# Install Plugins
vim -c "PlugInstall" -c "q" -c "q"
