#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)

ln -s $@ $DIRECTORY/vimrc $HOME/.vimrc
ln -s $@ $DIRECTORY/bashrc $HOME/.bashrc
ln -s $@ $DIRECTORY/vim $HOME/.vim
ln -s $@ $DIRECTORY/ctags $HOME/.ctags
ln -s $@ $DIRECTORY/pythonrc $HOME/.pythonrc

# setup git global settings

# no real need to alias this, but standard to always look for ~/.gitignore
ln -s $@ $DIRECTORY/gitignore_global $HOME/.gitignore

git config --global alias.st  status
git config --global alias.ci  commit
git config --global alias.co  checkout
git config --global alias.lg  "log -p"
git config --global alias.ls  ls-files

