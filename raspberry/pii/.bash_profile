
PATH=$PATH:/opt/golang/go/bin:$HOME/local/bin:$HOME/.local/bin:$HOME/apps/scripts/bin:$HOME/apps/scripts/bin/statusbar

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

GOPATH=/opt/golang/go
source "$HOME/.cargo/env"

XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share

LOCATION=Osasco
#LOCATION=Sao_Paulo

export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT ];
then
    export PATH="$PYENV_ROOT/bin:$PATH"
    export PYENV_BIN=$PYENV_ROOT/bin/pyenv
fi

# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && . .xsession
# [[ -z $DISPLAY ]] && . .xsession
