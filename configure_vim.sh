#!/bin/bash
# IMPORTANT: The folder that will hold the quickfix history must not be deleted, so that I
#            can be able to go back to my saved quickfixes even if I reconfigure vim.
set -e

rm -fr ~/.vim ~/.vimrc ~/.vimi* .vim-* ~/vim-sessions; ln -s /storage/src/dot_files/.vimrc ~/.vimrc && \
ln -s /storage/src/dot_files/.vim ~/.vim && rm -fr ~/.vim/bundle && mkdir ~/.vim/bundle && \
mkdir -p ~/.vim-quickfix-history && \
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
vim +PluginInstall +all +qa
# below makes a fix to the vim-agriculture plugin to exclude unnecessary string that breaks search
find /storage/src/dot_files/.vim/bundle/vim-agriculture/plugin -type f -name *.vim -exec sed -i -e 's/\$//g' {} \;
# Below installs LeaderF plugin C Extension for better performance:
echo 'On the next vim startup, run ":LeaderfInstallCExtension", which installs LeaderF plugin C Extension for better performance.'
