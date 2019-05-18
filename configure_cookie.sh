#!/bin/bash
cd /tmp && \
git clone https://github.com/bbugyi200/cookie && \
cd cookie && \
make DESTDIR=$HOME/.local/share/cookie PREFIX= install && \
cd $HOME/.local/share/cookie && \
ls
