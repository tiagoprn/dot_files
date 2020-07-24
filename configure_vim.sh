#!/bin/bash
# IMPORTANT: The folder that will hold the quickfix history must not be deleted, so that I
#            can be able to go back to my saved quickfixes even if I reconfigure vim.
rm -fr ~/.vim ~/.vimrc ~/.vimi* .vim-* ~/vim-sessions; ln -s /storage/src/dot_files/.vimrc ~/.vimrc && \
ln -s /storage/src/dot_files/.vim ~/.vim && rm -fr ~/.vim/bundle && mkdir ~/.vim/bundle && \
mkdir ~/.vim-quickfix-history && \
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
vim +PluginInstall +all
