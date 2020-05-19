#!/bin/bash
rm -fr ~/.vim ~/.vimrc ~/.vimi* .vim-*; ln -s /storage/src/dot_files/.vimrc ~/.vimrc && \
ln -s /storage/src/dot_files/.vim ~/.vim && rm -fr ~/.vim/bundle && mkdir ~/.vim/bundle && \
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && \
vim +PluginInstall +all
