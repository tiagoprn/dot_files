#!/bin/sh
#
# ufetch-ubuntu - tiny system info for ubuntu

# based on the original project https://gitlab.com/jschx/ufetch

## INFO

# user is already defined
host="$(hostname)"
os="$(lsb_release -ds)"
kernel="$(uname -sr)"
uptime="$(uptime -p | sed 's/up //')"
packages="$(dpkg -l | wc -l)"
shell="$(basename "${SHELL}")"

## UI DETECTION

parse_rcs() {
	for f in "${@}"; do
		wm="$(tail -n 1 "${f}" 2> /dev/null | cut -d ' ' -f 2)"
		[ -n "${wm}" ] && echo "${wm}" && return
	done
}

rcwm="$(parse_rcs "${HOME}/.xinitrc" "${HOME}/.xsession")"

ui='unknown'
uitype='UI'
if [ -n "${DE}" ]; then
	ui="${DE}"
	uitype='DE'
elif [ -n "${WM}" ]; then
	ui="${WM}"
	uitype='WM'
elif [ -n "${XDG_CURRENT_DESKTOP}" ]; then
	ui="${XDG_CURRENT_DESKTOP}"
	uitype='DE'
elif [ -n "${DESKTOP_SESSION}" ]; then
	ui="${DESKTOP_SESSION}"
	uitype='DE'
elif [ -n "${rcwm}" ]; then
	ui="${rcwm}"
	uitype='WM'
elif [ -n "${XDG_SESSION_TYPE}" ]; then
	ui="${XDG_SESSION_TYPE}"
fi

ui="$(basename "${ui}")"

## DEFINE COLORS

# probably don't change these
if [ -x "$(command -v tput)" ]; then
	bold="$(tput bold)"
	black="$(tput setaf 0)"
	red="$(tput setaf 1)"
	green="$(tput setaf 2)"
	yellow="$(tput setaf 3)"
	blue="$(tput setaf 4)"
	magenta="$(tput setaf 5)"
	cyan="$(tput setaf 6)"
	white="$(tput setaf 7)"
	reset="$(tput sgr0)"
fi

# you can change these
lc="${reset}${bold}${yellow}"       # labels
nc="${reset}${bold}${yellow}"       # user and hostname
ic="${reset}"                       # info
c0="${reset}${green}"               # first color

## OUTPUT

cat <<EOF

${c0} %######################################@ | ${nc}${USER}${ic}@${nc}${host}${reset}
${c0} = ...................................  * | ${lc}OS:        ${ic}${os}${reset}
${c0} + :==================================. # | ${lc}KERNEL:    ${ic}${kernel}${reset}
${c0} + :==================================. # | ${lc}UPTIME:    ${ic}${uptime}${reset}
${c0} + ..:.  .:-==================-:.  .:.  # | ${lc}PACKAGES:  ${ic}${packages}${reset}
${c0} @%@%-  :-=========----=========-:  -%@%@ | ${lc}SHELL:     ${ic}${shell}${reset}
${c0} @@*. -=======-:...::::...:========- .*@@ |
${c0} @+ .=======-. -+#@@@@@@#+: .-=======. +@ |
${c0} # .=======- .#@@@@@@@@@@@@#. -=======. # |
${c0} - :=======  %@@@@@@@@@@@@@@%  =======: - |
${c0} - :=======  %@@@@@@@@@@@@@@%  =======: - |
${c0} # .=======- .#@@@@@@@@@@@@#. -=======. # |
${c0} @+ .=======-. :+#%@@@@@#+: .-=======. +@ |
${c0} @@*. -========:....::....:========- .*@@ |
${c0} @%@%-  :-=========----=========-:  =%@%@ |
${c0} + ..:.  .:-==================-:.  .:.  # | ON THE BRIGHTEST DAY,
${c0} + :==================================. # | ON THE BLACKEST NIGHT,
${c0} + :==================================. # | NO EVIL SHALL ESCAPE MY SIGHT.
${c0} = ...................................  * | LET THOSE WHO WORSHIP EVIL'S MIGHT,
${c0} %######################################@ | BEWARE MY POWER: GREEN LANTERN'S LIGHT! ${reset}

EOF

cat /storage/src/dot_files/welcome.txt
