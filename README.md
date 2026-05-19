# hyprland
collection of dot config files for hyprland with a simple install script for a fresh Arch linux with yay

You can grab the config files and install packages by hand with this commnad
```
yay -S hyprland kitty waybar hyprmod \
    hyprpaper hyprlock hypridle hyprpolkitagent hyprsunset \
    fuzzel hyprshutdown swaync thunar file-roller thunar-archive-plugin \
    ttf-jetbrains-mono-nerd noto-fonts-emoji \
    python-requests starship \
    pipewire wireplumber pipewire-pulse \
    satty grim slurp pavucontrol \
    wl-clipboard cliphist playerctl brightnessctl \
    xdg-utils xdg-user-dirs qt5-wayland qt6-wayland \
    gvfs gvfs-mtp udisks2 udiskie \
    network-manager-applet bluez bluez-utils blueman nwg-look \
    unzip zip p7zip xdg-user-dirs-gtk \
    btop jq ripgrep fd fzf zoxide \
    tumbler ffmpegthumbnailer \
    dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland
```

Or you can use the attached script "set-hypr" to install everything for you.

`set-hypr` now keeps going through optional failures and prints a final summary of installed, already-present, and failed packages plus failed setup steps.

This setup now includes HyprMod as a native settings app for Hyprland. The main config is `~/.config/hypr/hyprland.lua`, and it sources `~/.config/hypr/hyprland-gui.conf`, which is the file HyprMod manages.

Locking is handled by Hyprlock via `~/.config/hypr/hyprlock.conf`.

Idle handling is managed by Hypridle via `~/.config/hypr/hypridle.conf`.

Audio is expected to run on PipeWire with `wireplumber` and the PulseAudio-compatible `pipewire-pulse` layer. Runtime controls use `wpctl`, while `pavucontrol` provides a GUI mixer.

`SUPER+SPACE` launches Fuzzel as the app selector.

`SUPER+M` opens a Fuzzel power menu that uses `hyprlock` for locking, `hyprshutdown` for logout, and `systemctl` for suspend, reboot, and shutdown.

Wallpaper is handled by Hyprpaper via `~/.config/hypr/hyprpaper.conf`, polkit auth is handled by `hyprpolkitagent`, and night light is handled by `hyprsunset` via `~/.config/hypr/hyprsunset.conf`.

GTK theming is handled by `nwg-look`.

Notifications are handled by `swaync`, which also provides a control center. `SUPER+SHIFT+N` toggles it, `SUPER+CTRL+N` toggles Do Not Disturb, and Waybar exposes a notification indicator.

Networking and Bluetooth applets are handled by `nm-applet --indicator` and `blueman-applet`, which integrate with the existing Waybar tray. `SUPER+W` opens `nm-connection-editor`, and `SUPER+B` opens `blueman-manager`.

Screenshots use `grim` + `slurp` + `satty`, so region capture opens directly into Satty for annotation.

The utility stack also includes `pavucontrol`, `wl-clipboard`, `cliphist`, `playerctl`, `xdg-utils`, `xdg-user-dirs`, `xdg-user-dirs-gtk`, `udiskie`, `gvfs-mtp`, `file-roller`, `thunar-archive-plugin`, `unzip`, `zip`, `p7zip`, `tumbler`, `ffmpegthumbnailer`, `btop`, `jq`, `ripgrep`, `fd`, and `fzf` for desktop integration, archives, thumbnails, and terminal quality-of-life.
