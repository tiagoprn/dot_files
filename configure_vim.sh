#!/bin/bash
rm -fr ~/.vim ~/.vimrc ~/.vimi* .vim-* ~/vim-sessions; ln -s /storage/src/dot_files/.vimrc ~/.vimrc && \
ln -s /storage/src/dot_files/.vim ~/.vim && rm -fr ~/.vim/bundle && mkdir ~/.vim/bundle && \
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
vim +PluginInstall +all
