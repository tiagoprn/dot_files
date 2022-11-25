# Tiling Window Manager utilities/packages

$ apt install rofi rofi-dev spacefm-gtk3

# docker

## Ubuntu 20.04
$ # add docker official repository GPG key:
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ # add docker repository to apt sources:
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
$ # update packages database
$ sudo apt update && sudo apt install docker-ce -y

# KVM with terraform provisioning

## Ubuntu 18.04

### Option 1 - quickemu

<https://github.com/quickemu-project/quickemu>


### Option 2 - KVM (manual installation)
$ sudo apt-get -y install qemu-kvm libvirt-bin virt-top  libguestfs-tools virtinst bridge-utils virt-manager
$ sudo modprobe vhost_net
$ sudo lsmod | grep vhost
$ echo "vhost_net" | sudo tee -a /etc/modules

$ # change the security driver to none, since ubuntu disables selinux by default:
$ vim /etc/libvirt/qemu.conf
```
security_driver = "none"
```

$ # Below enables kvm service (libvirtd):
$ sudo systemctl start libvirtd
$ sudo systemctl enable libvirtd

After finished, logout and login (you were added to the libvirt group, and need
to do that so you have permission on the libvirt socket).

kvm configuration files are at `/etc/libvirt`. The one that controls the daemon is `libvirtd.conf`.

$ # Create and enable a default storage pool
https://github.com/tiagoprn/devops/blob/master/cheats/kvm.cheat (use pool-name=`default`)

#### To enable port forwarding:

(reference: <https://wiki.libvirt.org/page/Networking#Forwarding_Incoming_Connections>)

```
$ sudo su
$ cp -farv /storage/src/devops/shellscripts/utils/kvm-port-forwarder/* /etc/libvirt/hooks
$ cd /etc/libvirt/hooks
$ chown root.root *
$ chmod 777 /etc/libvirt/hooks/qemu
```

The hooks that allow port forwarding will be installed by this script at
`/etc/libvirt/hooks`. To create a new forwarding, it will use iptables.
You will first have to stop the VM and then configure its' forwarding at
`/etc/libvirt/hooks/qemu`. Then, restart the `libvirtd` service and start
the guest.

### Terraform
```
$ sudo su
$ mkdir -p /opt/src/terraform
$ cd /opt/src/terraform
$ export TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'` && \
  wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip && \
  unzip terraform_${TER_VER}_linux_amd64.zip
$ cp -farv terraform /usr/local/bin

$ # Install the kvm provider
(adapt instructions from [here](https://tiagopr.nl/posts/published/terraform-on-arch-linux/))
```

## Ubuntu 20.04

### KVM
<https://www.ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/>
or
<https://github.com/quickemu-project/quickemu>

# APT PACKAGES

## Ubuntu 20.04
sudo apt install -y build-essential apt-transport-https ca-certificates curl software-properties-common bash-completion net-tools htop sysstat ncdu xclip pandoc texlive texlive-latex-extra icdiff tree gitg tig cowsay ioping stress-ng iotop gimp inkscape rclone nmap source-highlight strace dnstracer xdotool s3fs python2 python3 python3-pip python3-all-dev numlockx font-manager qemu qemu-kvm acpi acpitool arandr feh imagemagick libjpeg-progs xautolock scrot rxvt-unicode gpick x11-apps sxiv mupdf mupdf-tools mps-youtube mplayer ffmpeg mpv vlc golang-go numix-gtk-theme numix-icon-theme materia-gtk-theme libncurses5-dev libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxcb-render0-dev libxpm-dev libxt-dev libxml2-dev libxmlsec1-dev libxslt-dev libncursesw5-dev fonts-firacode mosh pavucontrol screenfetch neofetch exiv2 libreadline-dev libbz2-dev libsqlite3-dev libssh-dev libssl-dev libffi-dev libpq-dev libjpeg-dev zlib1g zlib1g-dev zlibc libtiff-dev libfreetype6 libfreetype6-dev liblcms2-2 liblcms2-dev libwebp-dev libwebp6 libopenjp2-7 libopenjp2-7-dev libopenjp3d7 libraqm0 libraqm-dev python2-dev python3-cffi figlet debhelper libpcap-dev xbacklight inxi tty-clock gparted cryptsetup kpartx tcptraceroute jq x11-xserver-utils python3-venv pipx ccze libxfixes-dev pencil2d mypaint python3-tk libev-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libpam0g-dev libjansson-dev librsvg2-dev fio python3-pyqt5 pyqt5-dev-tools qttools5-dev-tools sysbench hdparm fsarchiver libnm-dev gir1.2-nm-1.0 qrencode resolvconf cmake cmake-data libasound2-dev libcurl4-openssl-dev libiw-dev libmpdclient-dev libpulse-dev libboost-program-options-dev libxcb1-dev libxcb-composite0-dev libxcb-ewmh2 libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev libxcb-xrm-dev pkg-config python3-xcbgen xcb xcb-proto libjsoncpp-dev libxi-dev libxslt1-dev asciidoc python3-venv zathura python3-pyudev flatpak supervisor supervisor-doc wyrd inotify-tools python3-gi gir1.2-gtk-3.0 python3-gi-cairo python3-cairo python3-setuptools python3-babel fonts-font-awesome slop gir1.2-appindicator3-0.1 pass secure-delete libtool-bin pulsemixer stalonetray dbus-cpp-dev-examples dbus-1-doc libdbus1.0-cil-dev libdbus-1-dev libnotify-dev libnotify-cil-dev libxrandr-dev libpango1.0-dev sxhkd wmctrl


# PYTHON LIBS/UTILS TO INSTALL THROUGH pipx

(see my repo devops/python/pipx)


# TO BE COMPILED / INSTALLED:

## rust
(install as root)
$ export RUSTUP_HOME=/opt/rust && export CARGO_HOME=/opt/rust && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ export PATH=$PATH:/opt/rust/bin
$ rustup install stable
$ rustup default stable
IMPORTANT: to be able to update cargo packages and install new ones, you must export the variables above each time:
$ export RUSTUP_HOME=/opt/rust && export CARGO_HOME=/opt/rust && export PATH=$PATH:/opt/rust/bin
(after cargo install/update, you can manually copy the binary from /opt/rust/bin/[binary] to /usr/bin)

## telegram-desktop
$ mkdir /opt/telegram && cd /opt/telegram
$ curl -L https://telegram.org/dl/desktop/linux -o tsetup.tar.xz
$ xz -d tsetup.tar.xz && tar xfv tsetup.tar && cd Telegram && ls
$ cd /storage/src/dot_files/app-launchers && ./setup-app-launcher.sh

## ripgrep
$ cargo install ripgrep

## glow
(to render markdown files on CLI)
$ git clone https://github.com/charmbracelet/glow.git
$ cd glow
$ go build
$ cp glow ~/.local/bin

## navi
$ cargo install navi

## xcolor
(useful to get colors from a screen's region)
$ cargo install xcolor

## fd
$ wget https://github.com/sharkdp/fd/releases/download/v8.1.1/fd_8.1.1_amd64.deb

## fzf
$ git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

## ytop
$ cargo install ytop  # as the normal user, to be available on my $HOME/.cargo/bin

## playerctl
$ wget http://ftp.nl.debian.org/debian/pool/main/p/playerctl/libplayerctl2_2.0.1-1_amd64.deb
$ wget http://ftp.nl.debian.org/debian/pool/main/p/playerctl/playerctl_2.0.1-1_amd64.deb

## tmux
$ /storage/src/devops/shellscripts/installers/install_tmux_on_home_folder.sh

## less with syntax highlight
sudo su
cd /opt && git clone https://github.com/wofr06/lesspipe.git && cd lesspipe && ./configure && ln -s /opt/lesspipe/lesspipe.sh /usr/local/bin/lesspipe.sh && ln -s /opt/lesspipe/code2color /usr/local/bin/code2color.sh

## curl (updated with support to json as stdout - which landed on 7.70.0)
$ sudo apt remove -y curl && sudo apt purge -y
$ sudo su
$ mkdir -p /opt/src
$ cd /opt/src
$ mkdir curl && cd curl
$ wget https://curl.haxx.se/download/curl-7.75.0.tar.gz
$ tar xfzv curl-7.75.0.tar.gz
$ cd curl-7.75.0
$ ./configure --with-ssl
$ make
$ make install
$ exit
$ sudo ldconfig  # fixes "curl: symbol lookup error: curl: undefined symbol: curl_url_cleanup"

## bat
$ sudo su
$ mkdir /opt/bat && cd /opt/bat
$ wget https://github.com/sharkdp/bat/releases/download/v0.12.1/bat-v0.12.1-x86_64-unknown-linux-gnu.tar.gz
$ tar xfzv bat-v0.12.1-x86_64-unknown-linux-gnu.tar.gz
$ ln -s /opt/bat/bat-v0.12.1-x86_64-unknown-linux-gnu/bat /usr/bin/bat

## entr (to listen on directory changes)
$ sudo su
$ cd /opt/src
$ wget http://eradman.com/entrproject/code/entr-4.6.tar.gz
$ tar xfzv entr-4.6.tar.gz
$ cd entr-4.6
$ ./configure
$ make test
$ make install

## simple tcp proxy in C (I can use to redirect local ports to guest ports on KVM)
$ sudo su
$ mkdir -p /opt/src
$ cd /opt/src
$ git clone https://github.com/kklis/proxy
$ cd proxy
$ make
$ cp -farv proxy /usr/local/bin

## polybar
$ sudo su
$ cd /opt/src
$ git clone https://github.com/jaagr/polybar.git
$ cd polybar
$ sudo ./build.sh

## picom
(picom is compton's fork, more modern and with more features. So, it uses the same configuration file as compton for now.)
$ sudo su
$ cd /opt/src
$ git clone https://github.com/pijulius/picom
$ cd picom
$ apt install -y meson asciidoc pandoc
$ meson --buildtype=release . build --prefix=/usr -Dwith_docs=true
$ /usr/bin/ninja -C build && /usr/bin/ninja -C build install

## unclutter (to auto-hide mouse pointer when idle)
$ sudo su
$ cd /opt/src
$ git clone https://github.com/Airblader/unclutter-xfixes
$ cd unclutter-xfixes
$ make
$ sudo make install

## ventoy (create a multiboot usb disk)
$ sudo su
$ cd /opt/src
$ mkdir -p ventoy && cd ventoy
$ curl -L https://github.com/ventoy/Ventoy/releases/download/v1.0.38/ventoy-1.0.38-linux.tar.gz | tar -xmpz
$ cd ventoy-1.0.38
$ ./Ventoy2Disk.sh (to check the manual page)
$ ./Ventoy2Disk.sh -g -s -L DATAKEEPER -i /dev/<disk> (e.g. /dev/sdb)

## screenkey
(a screencast tool to display your keys as you type them)
$ sudo su
$ cd /opt/src
$ git clone https://gitlab.com/screenkey/screenkey.git
$ cd screenkey
$ ./setup.py install

## pamixer
$ sudo su
$ cd /opt/src
$ git clone https://github.com/cdemoulins/pamixer.git
$ sudo meson setup build
$ sudo meson compile -C build
$ sudo meson install -C build

## clipnotify (notifies every time something is added to the clipboard)
$ cd ~/src
$ git clone https://github.com/cdown/clipnotify
$ cd clipnotify
$ make
$ cp clipnotify ~/.local/bin
(it is used by `/storage/src/dot_files/tiling-window-managers/scripts/clipnotify.sh`)

## dragon (drag-and-drop simple widget)
$ cd ~/src
$ git clone https://github.com/mwh/dragon
$ cd dragon
$ make
$ make install

## dmenu (distrotube customization)
$ sudo su
$ cd /opt/src
$ https://gitlab.com/dwt1/dmenu-distrotube.git
$ cd dmenu-distrotube
$ make
$ make install

## sqlite3
(<https://www.sqlite.org/howtocompile.html>)
$ sudo su
$ cd /opt/src
$ mkdir sqlite3
$ wget https://www.sqlite.org/2021/sqlite-autoconf-3350300.tar.gz
$ cd sqlite3
$ tar xfzv sqlite-autoconf-3350300.tar.gz
$ cd sqlite-autoconf-3350300
$ gcc -Os -I. -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_FTS4 \
   -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_JSON1 \
   -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS \
   -DHAVE_USLEEP -DHAVE_READLINE \
   shell.c sqlite3.c -ldl -lm -lreadline -lncurses -o sqlite3
$ cp -farv sqlite3 /usr/bin

## styli.sh (change wallpapers dinamically, based on reddit or usplash)
$ cd /opt
$ sudo git clone https://github.com/thevinter/styli.sh.git
$ sudo chown -R $(id -u):$(id -g) styli.sh
$ mkdir -p $HOME/.config/styli.sh
$ cp -farv /opt/styli.sh/subreddits $HOME/.config/styli.sh/
$ echo 'MinimalWallpaper' >> $HOME/.config/styli.sh/subreddits

## alacritty
$ sudo su
$ cd /opt/src
$ git clone https://github.com/alacritty/alacritty.git
$ cd alacritty
$ git tag
$ git checkout v0.8.0
$ cargo build --release
$ cp target/release/alacritty /usr/bin/

## lazygit (to use git inside neovim)
$ sudo su
$ cd /opt/src
$ mkdir lazygit && cd lazygit
$ wget https://github.com/jesseduffield/lazygit/releases/download/v0.28.2/lazygit_0.28.2_Linux_x86_64.tar.gz
$ tar xfzv lazygit_0.28.2_Linux_x86_64.tar.gz
$ cp lazygit /usr/bin/

## betterlockscreen
$ sudo su
$ cd /opt/src/
$ git clone https://github.com/Raymo111/i3lock-color.git
$ cd i3lock-color
$ ./install-i3lock-color.sh
$ cd /opt/src
$ mkdir betterlockscreen
$ cd betterlockscreen
$ wget https://github.com/pavanjadhaw/betterlockscreen/archive/refs/heads/main.zip
$ unzip main.zip
$ cd betterlockscreen-main
$ cp betterlockscreen /usr/local/bin

## dunst (most recent version, with support to pause notifications for a while - Do not Disturb mode)
$ sudo su
$ cd /opt/src
$ git clone https://github.com/dunst-project/dunst.git
$ cd dunst
$ make WAYLAND=0  # https://github.com/dunst-project/dunst#make-parameters
$ make WAYLAND=0 install

## autorandr
$ sudo su
$ cd /opt/src
$ git clone https://github.com/phillipberndt/autorandr
$ cd autorandr
$ make install
$ systemctl daemon-reload
$ systemctl enable autorandr.service
$ systemctl enable autorandr-lid-listener.service
$ udevadm control --reload-rules

## git-auto-sync
$ sudo su
$ mkdir /opt/src/git-auto-sync && cd /opt/src/git-auto-sync
$ wget https://github.com/GitJournal/git-auto-sync/releases/download/v1.5/git-auto-sync_1.5_linux_amd64.deb
$ dpkg -i git-auto-sync_1.5_linux_amd64.deb

## rdrview (firefox reader as a CLI program)
$ sudo su
$ cd /opt/src
$ git clone https://github.com/eafer/rdrview
$ cd rdrview
$ make
$ make install

## remint (TUI for remind)
$ sudo su
$ cd /opt/src
$ git clone https://git.sr.ht/~mlaparie/remint
$ cd remint
$ ln -s /opt/src/remint/remint.sh /usr/bin/remint.sh

## clifm (file manager with command mode)
$ sudo su
$ cd /opt/src
$ git clone https://github.com/leo-arch/clifm.git
$ cd clifm
$ sudo make install

## activitywatch
$ sudo su
$ cd /opt/src
$ wget https://github.com/ActivityWatch/activitywatch/releases/download/v0.11.0/activitywatch-v0.11.0-linux-x86_64.zip
$ unzip activitywatch-v0.11.0-linux-x86_64.zip

## git-ui (more performant than lazygit)
$ cargo install gitui

### Directories
- categories: `/storage/docs/notes/activitywatch`
- data: `~/.local/share/activitywatch`
- config: `~/.config/activitywatch`
- logs: `~/.cache/activitywatch/log`
- Cache: `~/.cache/activitywatch`


## SNAP INSTALLS
$ sudo snap install youtube-dl
$ sudo snap install chromium
$ sudo snap install firefox
$ sudo snap install slack
$ sudo snap install spotify
$ sudo snap install multipass --classic
$ sudo snap install ascii-image-converter

Import: if snaps are not available, try to use docker images with the [watchtower container](https://containrrr.dev/watchtower/usage-overview/) to auto update the images.


## FLATPAK installs

### qutebrowser

- Install:
	$ flatpak install --user https://flathub.org/repo/appstream/org.qutebrowser.qutebrowser.flatpakref

- Run (allowing the flatpak to access the home filesystem - which by default it does not, because of the flatpak sandbox):
	$ flatpak run --filesystem=host org.qutebrowser.qutebrowser -B ~/.local/share/qutebrowser/personal

- Update:
	$ flatpak --user update org.qutebrowser.qutebrowser

- Uninstall:
	$ flatpak --user uninstall org.qutebrowser.qutebrowser

### flameshot

- Install:
	$ flatpak install flathub org.flameshot.Flameshot

- Run:
	$ flatpak run --filesystem=host org.flameshot.Flameshot

---

# TODO
- Convert this file into an ansible playbook to automate everything in this
  document here: `/storage/src/devops/ansible-playbooks/ubuntu/22.04/workstation`
- wpgtk
- configure a `.docker` domain with dnsmasq (it is already bundled on Ubuntu, check on debian/raspbian)
