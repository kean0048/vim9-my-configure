#!/bin/sh

cp -rf vim ~/.vim
cp -rf vimrc ~/.vimrc

sudo apt update
sudo apt install cscope universal-ctags
sudo apt install vim-python*

# open vim and input :PlugInstall
# Enter .vim/Plug/YouCompileMe and execute git submodule update --recursive --remote and ./install.sh --clang-completer
# OK YCM fine.
