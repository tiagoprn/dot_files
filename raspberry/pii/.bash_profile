echo  "Sourcing .profile, since it is not automatically sourced by bash...[WAIT]"
. "$HOME/.profile"
echo  "Sourcing .profile...[DONE]"

# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && . .xprofile
[[ -z $DISPLAY ]] && . .xprofile
