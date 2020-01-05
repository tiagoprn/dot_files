#!/bin/bash
rm -fr ~/.terminfo; ln -s /storage/src/dot_files/.terminfo ~/.terminfo && rm -fr ~/.tmux ~/.tmux.conf ; mkdir ~/.tmux && ln -s /storage/src/dot_files/.tmux.conf ~/.tmux.conf && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
