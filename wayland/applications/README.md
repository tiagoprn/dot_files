# Applications directory (`~/.local/share/applications/`)

## WHAT

This folder holds `.desktop` files: small text entries that tell your Linux
desktop (GNOME, KDE, Cinnamon, XFCE, ...) that an application exists. The
desktop reads them to build the applications menu, the app grid, and the
search results when you press the Super key.

Example entry in this folder:

- `firefox-ai-profile.desktop` - launches Firefox with the profile `ai`
  (`firefox -P ai`).

## WHY

Linux desktops do not scan your home folder for launchers. They only look in
the standard XDG data directories:

| Location                          | Purpose                          |
|-----------------------------------|----------------------------------|
| `/usr/share/applications/`        | System-wide launchers (root)     |
| `~/.local/share/applications/`    | Launchers for your user only     |

A `.desktop` file placed anywhere else (including directly in `$HOME`) is
ignored. Putting your custom launcher here means:

1. It appears in your applications list without editing system files.
2. It survives desktop environment changes, because every major desktop reads
   this path.
3. It stays yours: no root access needed, and it is not overwritten by
   package updates.

## HOW

1. Create a text file ending in `.desktop` inside this folder:

   ```ini
   [Desktop Entry]
   Version=1.0
   Type=Application
   Name=Firefox AI Profile
   Exec=firefox -P ai
   Icon=firefox
   Terminal=false
   Categories=Network;WebBrowser;
   ```

2. Mark it executable so the desktop treats it as trusted:

   ```bash
   chmod +x ~/.local/share/applications/firefox-ai-profile.desktop
   ```

3. Log out and back in (or restart the desktop shell) if the entry does not
   show up right away.

Key fields:

- `Name` - what you see in the applications list.
- `Exec` - the command that runs. Use `false` in `Terminal` for GUI apps.
- `Icon` - an icon name or a full path to an image file.

To remove an entry, delete its `.desktop` file from this folder.

Troubleshooting:

- Entry missing? Check the file ends in `.desktop` and is executable
  (`ls -l`). Some file managers also need "Allow Launching" in the file's
  right-click menu.
- Invalid entry? Run `desktop-file-validate <file>`.
- Nothing happens on click? Test the `Exec` command directly in a terminal.