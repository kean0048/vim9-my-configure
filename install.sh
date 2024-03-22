#!/bin/sh

# 获取linux发行版名称
function get_linux_distro()
{
    if grep -Eq "Ubuntu" /etc/*-release; then
        echo "Ubuntu"
    elif grep -Eq "Debian" /etc/*-release; then
        echo "Debian"
    elif grep -Eq "fedora" /etc/*-release; then
        echo "fedora"
    else
        echo "Unknown"
    fi
}

function install_vimplus_on_linux()
{
    distro=`get_linux_distro`
    echo "Linux distro: "${distro}

    if [ ${distro} == "Ubuntu" ]; then
        install_vimplus_on_ubuntu_debian
    elif [ ${distro} == "Debian" ]; then
        install_vimplus_on_ubuntu_debian
    elif [ ${distro} == "fedora" ]; then
        install_vimplus_on_fedora
    else
        echo "Not support linux distro: "${distro}
    fi
}

function install_vimplus_on_ubuntu_debian()
{
	sudo apt update
	sudo apt install cscope universal-ctags vim-python*
}

function install_vimplus_on_fedora()
{
	sudo dnf update
	sudo dnf install -y vim ctags cscope gcc gcc-c++ automake kernel-devel cmake python3-devel
}

function copy_file_to_local()
{
	cp -rf vim $HOME/.vim
	cp -rf vimrc $HOME/.vimrc
	cp -rf vimrc.custom.config $HOME/.vimrc.custom.config
}

# open vim and input :PlugInstall
# Enter .vim/Plug/YouCompileMe and execute git submodule update --recursive --remote and ./install.sh --clang-completer
# OK YCM fine.
# 安装vim插件
function install_vim_plugin()
{
	# Install Plugins
	vim -c "PlugInstall" -c "q" -c "q"
}

# 安装ycm插件
function install_ycm()
{
    git clone https://gitee.com/chxuan/YouCompleteMe-clang.git ~/.vim/plugged/YouCompleteMe

    cd ~/.vim/plugged/YouCompleteMe
    distro=`get_linux_distro`
    read -p "Please choose to compile ycm with python2 or python3, if there is a problem with the current selection, please choose another one. [2/3] " version
    if [[ $version == "2" ]]; then
        echo "Compile ycm with python2."
        {
            python2.7 ./install.py --clang-completer
        } || {
            echo "##########################################"
            echo "Build error, trying rebuild without Clang."
            echo "##########################################"
            python2.7 ./install.py
        }
    else
        echo "Compile ycm with python3."
	{
	    python3 ./install.py --clang-completer
	} || {
	    echo "##########################################"
	    echo "Build error, trying rebuild without Clang."
	    echo "##########################################"
	    python3 ./install.py
	}
    fi
}

# main函数
function main()
{
    type=$(uname)
    echo "Platform type: "${type}

    if [ ${type} == "Linux" ]; then
        install_vimplus_on_linux
    else
        echo "Not support platform type: "${type}
    fi
    
    copy_file_to_local
    install_ycm
    install_vim_plugin
}

# 调用main函数
main
