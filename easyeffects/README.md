# Audio setup for Kuba Microphone with clean voice

1) Flatpak: install `pwvucontrol` (pipewire volume control).
In "Cards", set the ones you do not want activated to "off".
Plug Kuba phone and headset to the USB-C DAC and port on the Docking Station.

2) Install easy-effects, to tune the Input (microphone) setup with noise supression and voice cleaning up.
Effects: Filter, Noise Reduction, Gate and Limiter.
Related packages on EndeavourOS: `sudo pacman -S --needed lsp-plugins-lv2 noise-suppression-for-voice easyeffects`

3) Create symlink to easy-effects configuration: `ln -s /storage/src/dot_files/easyeffects $HOME/.local/share/easyeffects`
