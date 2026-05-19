# hyprland
collection of dot config files for hyprland with a simple install script for a fresh Arch linux with yay

You can grab the config files and install packages by hand with this commnad
```
yay -S hyprland kitty waybar \
    hyprpaper hyprlock hypridle hyprpolkitagent hyprsunset \
    fuzzel hyprshutdown swaync thunar file-roller thunar-archive-plugin \
    ttf-jetbrains-mono-nerd noto-fonts-emoji \
    python-requests starship \
    pipewire wireplumber pipewire-pulse \
    satty grim slurp pavucontrol \
    wl-clipboard cliphist playerctl brightnessctl power-profiles-daemon \
    xdg-utils xdg-user-dirs qt5-wayland qt6-wayland \
    gvfs gvfs-mtp udisks2 udiskie \
    networkmanager network-manager-applet bluez bluez-utils blueman nwg-look \
    unzip zip p7zip xdg-user-dirs-gtk \
    btop jq ripgrep fd fzf zoxide \
    tumbler ffmpegthumbnailer \
    dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland
```

If you are on AMD Radeon hardware, install the GPU/video stack as well:
```bash
yay -S mesa vulkan-radeon libva-mesa-driver
```

Or you can use the attached script "set-hypr" to install everything for you.

`set-hypr` now keeps going through optional failures and prints a final summary of installed, already-present, and failed packages plus failed setup steps.

## Fresh Arch install: how to run

After a fresh Arch install:

1. Install the basics you need first: `git`, `base-devel`, and `yay`, and make sure you already have working internet access.
2. Clone this repo and enter it:
   ```bash
   git clone https://github.com/raathi/hyprland.git
   cd hyprland
   ```
3. Make the installer executable and run it:
   ```bash
   chmod +x set-hypr
   ./set-hypr
   ```
4. Answer the prompts for base package install, optional AMD Radeon packages, config copy, optional Starship setup, and optional ASUS ROG support.
5. At the end, either let the script start Hyprland or launch it yourself with:
   ```bash
   Hyprland
   ```

The main Hyprland config is `~/.config/hypr/hyprland.lua`.

Locking is handled by Hyprlock via `~/.config/hypr/hyprlock.conf`.

Idle handling is managed by Hypridle via `~/.config/hypr/hypridle.conf`.

Audio is expected to run on PipeWire with `wireplumber` and the PulseAudio-compatible `pipewire-pulse` layer. Runtime controls use `wpctl`, while `pavucontrol` provides a GUI mixer.

For AMD laptop hardware like the Ryzen 7 5700U with Radeon graphics, `set-hypr` now asks before installing `mesa`, `vulkan-radeon`, and `libva-mesa-driver`. Generic laptop power profile switching still uses the base `power-profiles-daemon` package.

`SUPER+SPACE` launches Fuzzel as the app selector.

`SUPER+M` opens a Fuzzel power menu that uses `hyprlock` for locking, `hyprshutdown` for logout, and `systemctl` for suspend, reboot, and shutdown.

Wallpaper is handled by Hyprpaper via `~/.config/hypr/hyprpaper.conf`, polkit auth is handled by `hyprpolkitagent`, and night light is handled by `hyprsunset` via `~/.config/hypr/hyprsunset.conf`.

GTK theming is handled by `nwg-look`.

Notifications are handled by `swaync`, which also provides a control center. `SUPER+SHIFT+N` toggles it, `SUPER+CTRL+N` toggles Do Not Disturb, and Waybar exposes a notification indicator.

Networking and Bluetooth applets are handled by `nm-applet --indicator` and `blueman-applet`, which integrate with the existing Waybar tray. `SUPER+W` opens `nm-connection-editor`, and `SUPER+B` opens `blueman-manager`. The installer also enables `NetworkManager`, `power-profiles-daemon`, and Bluetooth on a fresh install.

Screenshots use `grim` + `slurp` + `satty`, so region capture opens directly into Satty for annotation.

The utility stack also includes `pavucontrol`, `wl-clipboard`, `cliphist`, `playerctl`, `xdg-utils`, `xdg-user-dirs`, `xdg-user-dirs-gtk`, `udiskie`, `gvfs-mtp`, `file-roller`, `thunar-archive-plugin`, `unzip`, `zip`, `p7zip`, `tumbler`, `ffmpegthumbnailer`, `btop`, `jq`, `ripgrep`, `fd`, and `fzf` for desktop integration, archives, thumbnails, and terminal quality-of-life.
