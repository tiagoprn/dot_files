# Audio setup for Kuba Microphone with clean voice

1) Flatpak: install `pwvucontrol` (pipewire volume control).
In "Cards", set the ones you do not want activated to "off".
Plug Kuba phone and headset to the USB-C DAC and port on the Docking Station.

2) Install easy-effects, to tune the Input (microphone) setup with noise supression and voice cleaning up.
Effects: Filter, Noise Reduction, Gate and Limiter.
Related packages on EndeavourOS: `sudo pacman -S --needed lsp-plugins-lv2 noise-suppression-for-voice easyeffects`

3) Create symlink to easy-effects configuration: `ln -s /storage/src/dot_files/easyeffects $HOME/.local/share/easyeffects`

4) Run EasyEffects as a systemd user service (headless daemon, survives reboots):

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/easyeffects.service <<'EOF'
[Unit]
Description=EasyEffects daemon
After=pipewire.service wireplumber.service

[Service]
ExecStart=/usr/bin/easyeffects --gapplication-service
Restart=on-failure

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now easyeffects.service
```

Notes:
- If a manual `easyeffects &` instance is already running, stop it first (`pkill -f easyeffects`),
  otherwise the unit exits instantly because the D-Bus name is already owned.
- Verify with: `systemctl --user status easyeffects.service --no-pager`
- The GUI (`easyeffects &`) is only a remote control; the daemon processes the mic without it.
- Arch's `easyeffects` package ships no unit file, hence the manual unit above.
