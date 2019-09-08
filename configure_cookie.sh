#!/bin/bash
rm -fr ~/.cookiecutters
ln -s /storage/src/devops/.cookiecutters ~/.cookiecutters && \
cd /tmp && \
git clone https://github.com/bbugyi200/cookie && \
cd cookie && \
make DESTDIR=$HOME/.local/share/cookie PREFIX= install && \
cd $HOME/.local/share/cookie && \
ls
