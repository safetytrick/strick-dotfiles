#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)

ln -s $@ $DIRECTORY/.vimrc $HOME/.vimrc
ln -s $@ $DIRECTORY/.bashrc $HOME/.bashrc
ln -s $@ $DIRECTORY/.vim $HOME/.vim
ln -s $@ $DIRECTORY/.ctags $HOME/.ctags

