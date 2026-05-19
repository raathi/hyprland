# Repository knowledge

## Commands

- Full setup on a fresh Arch system is driven by the repository script:
  ```bash
  chmod +x set-hypr
  ./set-hypr
  ```
- The README also documents the manual package install path:
  ```bash
  yay -S hyprland kitty waybar hyprmod \
      hyprpaper hyprlock hypridle hyprpolkitagent hyprsunset \
      fuzzel hyprshutdown swaync thunar file-roller thunar-archive-plugin \
      ttf-jetbrains-mono-nerd noto-fonts-emoji \
      python-requests starship \
      pipewire wireplumber pipewire-pulse \
      satty grim slurp pavucontrol \
      wl-clipboard cliphist playerctl brightnessctl \
      xdg-utils xdg-user-dirs xdg-user-dirs-gtk qt5-wayland qt6-wayland \
      gvfs gvfs-mtp udisks2 udiskie \
      network-manager-applet bluez bluez-utils blueman nwg-look \
      unzip zip p7zip \
      btop jq ripgrep fd fzf zoxide \
      tumbler ffmpegthumbnailer \
      dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland
  ```
- There is no automated build, lint, or test suite in this repository. The only standalone executable checked into the repo is the Waybar weather helper, which can be smoke-tested directly:
  ```bash
  python waybar/scripts/waybar-wttr.py
  ```

## High-level architecture

- This repository is a deployable Hyprland desktop config bundle for Arch Linux. Top-level directories map directly to `~/.config` destinations (`hypr`, `kitty`, `satty`, `swaync`, `waybar`, `fuzzel`), and `starship.toml` is copied into `~/.config` as a standalone file.
- `set-hypr` is the orchestration entrypoint. It updates packages with `yay`, optionally disables Wi-Fi powersave, installs the desktop dependencies including `hyprmod`, `hyprpaper`, `hyprlock`, `hypridle`, `hyprpolkitagent`, `hyprsunset`, `swaync`, and the shell utility bundle (`btop`, `jq`, `ripgrep`, `fd`, `fzf`, `zoxide`), copies config directories into `~/.config`, marks helper scripts executable, initializes XDG user directories, optionally enables Starship in `.bashrc`, optionally installs ASUS ROG support, and prints a final summary of installed, already-present, and failed packages plus failed setup steps.
- `hypr/hyprland.lua` is the runtime hub for Hyprland 0.55+. It starts Hyprpaper, imports Wayland environment variables into systemd, restarts the packaged portal user services, launches `hyprpolkitagent`, starts `hyprsunset`, `udiskie`, `nm-applet --indicator`, `blueman-applet`, clipboard watchers, HyprIdle, `swaync`, and Waybar, sources `~/.config/hypr/hyprland-gui.conf` for HyprMod-managed settings via `hyprctl keyword source`, and defines the keybindings that tie together the rest of the repo (`kitty`, `thunar`, `fuzzel`, `hyprmod`, `hyprlock`, the Fuzzel-backed power menu, screenshots, audio, clipboard history, GTK theming, notifications, networking, Bluetooth, brightness, and ASUS-specific actions).
- `hypr/hyprland-gui.conf` is the tracked stub for HyprMod. HyprMod writes its own managed settings there instead of editing the hand-maintained `hyprland.lua`.
- `hypr/hyprpaper.conf` holds the wallpaper configuration for Hyprpaper and points at the tracked wallpaper image in the same config directory.
- `hypr/hyprlock.conf` holds the lockscreen UI because Hyprlock looks for its config under the Hypr config directory rather than in a separate top-level folder.
- `hypr/hypridle.conf` is the idle policy. It starts Hyprlock on lock events, turns displays off after a short idle period, and suspends later.
- `hypr/hyprsunset.conf` holds the time-based night-light profiles for `hyprsunset`.
- `fuzzel/fuzzel.ini` holds the launcher theme and sizing. The repository uses Fuzzel both as the app launcher and as the dmenu-style frontend for helper scripts.
- `hypr/clipboard-menu.sh` is a small Fuzzel-backed clipboard picker that reads from `cliphist` and copies the selected entry back to the Wayland clipboard.
- `hypr/power-menu.sh` is the power-menu entrypoint. It uses `fuzzel --dmenu` to offer lock, logout, suspend, reboot, and shutdown actions, then dispatches to `hyprlock`, `hyprshutdown`, or `systemctl`.
- `satty/config.toml` holds the screenshot annotation defaults after replacing Swappy. The main screenshot keybind pipes a selected `grim` capture into `satty --filename -`.
- `swaync/config.json` and `swaync/style.css` define the notification daemon and control-center layout after the move away from Mako.
- `waybar/config.jsonc` and `waybar/style.css` are a pair: JSONC defines module layout and behavior, while CSS styles the exact module IDs used there. The left side uses separate time, calendar, weather, and Hyprland workspace modules; the custom weather module shells out to `~/.config/waybar/scripts/waybar-wttr.py`; the custom power-profile module expects `asusctl` plus a Waybar signal refresh; and the bar includes a `swaync` status button.
- Audio is expected to use PipeWire with `wireplumber` and `pipewire-pulse`. The bar still uses Waybar's PulseAudio-compatible modules for display, but runtime controls now use `wpctl` and `pavucontrol`.
- The base utility stack also includes `pavucontrol`, `wl-clipboard`, `cliphist`, `playerctl`, `xdg-utils`, `xdg-user-dirs`, `xdg-user-dirs-gtk`, `udisks2`, `udiskie`, `network-manager-applet`, `blueman`, `gvfs-mtp`, `file-roller`, `thunar-archive-plugin`, `satty`, `unzip`, `zip`, `p7zip`, `tumbler`, `ffmpegthumbnailer`, `btop`, `jq`, `ripgrep`, `fd`, `fzf`, `zoxide`, and `nwg-look`, so future integrations can assume standard Wayland clipboard, media-control, archive, screenshot annotation, thumbnail, removable-drive, networking, Bluetooth, terminal productivity, and GTK-theming tools are available after running the installer.
- The visual theme is distributed rather than centralized. Kitty pulls in `kitty/mocha.conf`, while Waybar, Swaync, Hyprlock, Hyprland borders, and Starship each restate their own fonts and colors to keep a matching dark theme.

## Key conventions

- Keep top-level repo names aligned with their final `~/.config` paths. `set-hypr` copies directories by name with `cp -R`, so renaming a directory or adding a new deployable config requires updating that script.
- Preserve the path assumptions baked into runtime config. `hypr/hyprland.lua` expects `~/.config/hypr/hong-kong-night.jpg`, `~/.config/hypr/hyprland-gui.conf`, `~/.config/hypr/hyprpaper.conf`, `~/.config/hypr/hyprsunset.conf`, `~/.config/hypr/clipboard-menu.sh`, and `~/.config/hypr/power-menu.sh`; Hyprlock expects `~/.config/hypr/hyprlock.conf`; Hypridle expects `~/.config/hypr/hypridle.conf`; `waybar/config.jsonc` expects `~/.config/waybar/scripts/waybar-wttr.py`; `swaync` expects `~/.config/swaync/config.json`.
- Keep HyprMod changes isolated to `hypr/hyprland-gui.conf`. Hand-maintained defaults and keybindings belong in `hypr/hyprland.lua`; GUI-managed overrides belong in the sourced file.
- When editing Waybar, treat `config.jsonc`, `style.css`, and `waybar/scripts/waybar-wttr.py` as one feature area. Module names such as `custom/power_profile` and `pulseaudio#microphone` must stay in sync with the CSS selectors that style them.
- Keep Waybar polling conservative. Expensive custom modules should refresh on slower intervals unless the UI really needs live updates; this repo intentionally keeps weather and power-profile polling relatively low-frequency.
- ASUS ROG support is intentionally optional but wired in multiple places. `set-hypr` installs `asusctl`, `supergfxctl`, and `rog-control-center`; `hyprland.lua` binds ASUS hardware keys; and Waybar exposes the current power profile through `custom/power_profile`.
- The repo assumes direct, interactive setup on a fresh Arch machine with `yay` available. Changes that alter package names, startup commands, or copied files should be reflected in both `README.md` and `set-hypr`.
