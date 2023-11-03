#!/bin/sh

cp -rf vim ~/.vim
cp -rf vimrc ~/.vimrc

sudo apt update
sudo apt install ctags cscope
sudo apt install vim-python*
