#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)

ln -s $@ $DIRECTORY/vimrc $HOME/.vimrc
ln -s $@ $DIRECTORY/bashrc $HOME/.bashrc
ln -s $@ $DIRECTORY/vim $HOME/.vim
ln -s $@ $DIRECTORY/ctags $HOME/.ctags
ln -s $@ $DIRECTORY/pythonrc $HOME/.pythonrc
ln -s $@ $DIRECTORY/git_template $HOME/.git_template

mkdir "$HOME/.vim/swap"

# setup git global settings

# no real need to alias this, but standard to always look for ~/.gitignore
ln -s $@ $DIRECTORY/gitignore_global $HOME/.gitignore

# todo add the rest of my aliases
git config --global alias.st  status
git config --global alias.ci  commit
git config --global alias.co  checkout
git config --global alias.lg  "log -p"
git config --global alias.ls  ls-files

git config --global init.templatedir '~/.git_template'

