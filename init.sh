#!/bin/bash
# usage ./init.sh
# creates links to standard dotfiles and directories managed by this dotfile repo
# sets up global git configuration

DIRECTORY=$(cd `dirname $0` && pwd)

if [ ! -L $HOME/.vimrc ] ; then
  ln -s $@ $DIRECTORY/vimrc $HOME/.vimrc
fi
if [ ! -L $HOME/.gvimrc ] ; then
  ln -s $@ $DIRECTORY/gvimrc $HOME/.gvimrc
fi
if [ ! -L $HOME/.bashrc ] ; then
  ln -s $@ $DIRECTORY/bashrc $HOME/.bashrc
fi
if [ ! -L $HOME/.bash_completion.d ] ; then
  ln -s $@ $DIRECTORY/bash_completion.d $HOME/.bash_completion.d
fi
if [ ! -L $HOME/.bash_completion ] ; then
  ln -s $@ $DIRECTORY/bash_completion $HOME/.bash_completion
fi
if [ ! -L $HOME/.vim ] ; then
  ln -s $@ $DIRECTORY/vim $HOME/.vim
fi
if [ ! -L $HOME/.ctags ] ; then
  ln -s $@ $DIRECTORY/ctags $HOME/.ctags
fi
if [ ! -L $HOME/.pythonrc ] ; then
  ln -s $@ $DIRECTORY/pythonrc $HOME/.pythonrc
fi
if [ ! -L $HOME/.git_template ] ; then
  ln -s $@ $DIRECTORY/git_template $HOME/.git_template
fi

mkdir -p "$HOME/.vim/swap"

# setup git global settings

# no real need to alias this, but standard to always look for ~/.gitignore
if [ ! -L $HOME/.gitignore ] ; then
  ln -s $@ $DIRECTORY/gitignore_global $HOME/.gitignore
fi

# todo add the rest of my aliases
git config --global alias.st  status
git config --global alias.ci  commit
git config --global alias.co  checkout
git config --global alias.lg  "log -p"
git config --global alias.ls  ls-files

git config --global init.templatedir '~/.git_template'
git config --global core.excludesfile '~/.gitignore'
