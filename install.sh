#!/bin/sh

cp -rf vim ~/.vim
cp -rf vimrc ~/.vimrc

sudo apt update
sudo apt install cscope universal-ctags
sudo apt install vim-python*
