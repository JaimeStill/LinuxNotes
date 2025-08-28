# [Omarchy](https://omarchy.org/)

Install according to [Getting Started](https://learn.omacom.io/2/the-omarchy-manual/50/getting-started).

Be sure to follow each section in sequence as they are listed in order of dependency.

## Applications

### Packages

Install the following packages (<kbd>Super+Alt+Space</kbd> -> Install -> (Package or AUR)):

```sh
azure-cli
caligula
ccid
ente-auth-bin
firefox
nvidia-container-toolkit
opensc
otf-geist-mono-nerd
pcsclite
```

Remove the following packages (<kbd>Super+Alt+Space</kbd> -> Remove -> Package):

```sh
1password-beta
1password-cli
typora
```

### Web Apps

Add the following Web Apps (<kbd>Super+Alt+Space</kbd> -> Add -> Web App):

[Dashboard Icons](https://dashboardicons.com/)

```sh
Claude
https://claude.ai
https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png
```

Remove the following Web Apps (<kbd>Super+Alt+Space</kbd> -> Remove -> Web App):

> [!TIP]
> Mark Web Apps with x to flag for removal.

```sh
Basecamp
ChatGPT
Discord
Figma
GitHub
Google* (all)
HEY
WhatsApp
X
Zoom
```

### Desktop Icons

Remove the following `.desktop` files from `~/.local/share/applications`:

```sh
dropbox.desktop
typora.desktop
```

## Font

<kbd>Super+Alt+Space</kbd> -> Style -> Font -> **GeistMono Nerd Font**

## Development SDKs and Claude Code

Install and use with [mise]().

```sh
mise install dotnet
mise install go
mise install node

mise use -g dotnet
mise use -g go
mise use -g node

npm i -g @anthropic-ai/claude-code
```

## Config

The following files are set at `~/.config`.

`alacritty/alacritty.toml`

```toml
general.import = [ "~/.config/omarchy/current/theme/alacritty.toml" ]

[env]
TERM = "xterm-256color"

[font]
normal = { family = "GeistMono Nerd Font" }
bold = { family = "GeistMono Nerd Font" }
italic = { family = "GeistMono Nerd Font" }
size = 10

[window]
padding.x = 14
padding.y = 14
decorations = "None"
opacity = 0.98

[keyboard]
bindings = [
{ key = "F11", action = "ToggleFullscreen" }
]
```

`hypr/bindings.conf`

```sh
# Application bindings
$terminal = uwsm app -- alacritty
$browser = omarchy-launch-browser

bindd = SUPER, return, Terminal, exec, $terminal --working-directory=$(omarchy-cmd-terminal-cwd)
bindd = SUPER, F, File manager, exec, uwsm app -- nautilus --new-window
bindd = SUPER, B, Browser, exec, uwsm app -- firefox
bindd = SUPER, M, Music, exec, uwsm app -- spotify
bindd = SUPER, N, Neovim, exec, $terminal -e nvim
bindd = SUPER, T, Activity, exec, $terminal -e btop
bindd = SUPER, D, Docker, exec, $terminal -e lazydocker
bindd = SUPER, G, Signal, exec, uwsm app -- signal-desktop
bindd = SUPER, slash, Passwords, exec, uwsm app -- 1password

# If your web app url contains #, type it as ## to prevent hyperland treat it as comments
bindd = SUPER, A, Claude, exec, omarchy-launch-webapp "https://claude.ai"
bindd = SUPER, Y, YouTube, exec, omarchy-launch-webapp "https://youtube.com/"

# Overwrite existing bindings, like putting Omarchy Menu on Super + Space
# unbind = SUPER, Space
# bindd = SUPER, SPACE, Omarchy menu, exec, omarchy-menu
```

`hypr/hyprlock.conf`

```sh
source = ~/.config/omarchy/current/theme/hyprlock.conf

background {
    monitor =
    color = $color
}

animations {
    enabled = false
}

input-field {
    monitor =
    size = 600, 100
    position = 0, 0
    halign = center
    valign = center

    inner_color = $inner_color
    outer_color = $outer_color
    outline_thickness = 4

    font_family = GeistMono Nerd Font
    font_color = $font_color

    placeholder_text =   Enter Password 󰈷 
    check_color = $check_color
    fail_text = <i>$PAMFAIL ($ATTEMPTS)</i>

    rounding = 0
    shadow_passes = 0
    fade_on_empty = false
}

auth {
    fingerprint:enabled = true
}
```

`hypr/monitors.conf`

This configuration is more specific to your setup. Be sure to use `hyprctl monitors` to determine your exact setup. See [Hyprland - Monitors](https://wiki.hypr.land/Configuring/Monitors/) for full details on configuring monitors in Hyprland.

**Desktop**

```sh
# See https://wiki.hyprland.org/Configuring/Monitors/
# List current monitors and resolutions possible: hyprctl monitors
# Format: monitor = [port], resolution, position, scale
# You must relaunch Hyprland after changing any envs (use Super+Esc, then Relaunch)

env = GDK_SCALE,1
monitor=,preferred,auto,auto
monitor=DP-1,3440x1440@120.00Hz,auto,auto

# Good compromise for 27" or 32" 4K monitors (but fractional!)
# env = GDK_SCALE,1.75
# monitor=,preferred,auto,1.666667

# Straight 1x setup for low-resolution displays like 1080p or 1440p
# env = GDK_SCALE,1
# monitor=,preferred,auto,1

# Example for Framework 13 w/ 6K XDR Apple display
# monitor = DP-5, 6016x3384@60, auto, 2
# monitor = eDP-1, 2880x1920@120, auto, 2
```

`nvim/lua/config/options.lua`

```lua
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true
```

`mimeapps.list`

```conf
[Default Applications]
image/png=imv.desktop
image/jpeg=imv.desktop
image/gif=imv.desktop
image/webp=imv.desktop
image/bmp=imv.desktop
image/tiff=imv.desktop
application/pdf=org.gnome.Evince.desktop
text/html=firefox.desktop
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop
x-scheme-handler/about=firefox.desktop
x-scheme-handler/unknown=firefox.desktop
video/mp4=mpv.desktop
video/x-msvideo=mpv.desktop
video/x-matroska=mpv.desktop
video/x-flv=mpv.desktop
video/x-ms-wmv=mpv.desktop
video/mpeg=mpv.desktop
video/ogg=mpv.desktop
video/webm=mpv.desktop
video/quicktime=mpv.desktop
video/3gpp=mpv.desktop
video/3gpp2=mpv.desktop
video/x-ms-asf=mpv.desktop
video/x-ogm+ogg=mpv.desktop
video/x-theora+ogg=mpv.desktop
application/ogg=mpv.desktop
```


## Configure Docker for CDI to Work with NVIDIA Container Toolkit

The following setup is necessary to enable GPU access to containers in Docker on Arch Linux.

```sh
# backup docker daemon config
sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.backup

# generate cdi configuration
sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

# write updated docker daemon config
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "bip": "172.17.0.1/16",
  "dns": [
    "8.8.8.8",
    "8.8.8.4",
    "1.1.1.1"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-file": "5",
    "max-size": "10m"
  },
  "runtimes": {
    "nvidia": {
      "args": [],
      "path": "nvidia-container-runtime"
    }
  },
  "features": {
    "cdi": true
  }
}
EOF

# restart docker daemon
sudo systemctl restart docker

# test with CDI
docker run --rm --device nvidia.com/gpu=all nvidia/cuda:13.0.0-runtime-ubuntu22.04 nvidia-smi
```

## Firefox CAC Setup

1. In Settings: Preferences -> Privacy & Security -> Certificates -> Security Devices.
2. Click Load and configure as follows:

    ```sh
    CAC Module
    /usr/lib/opensc-pkcs11.so
    ```

## Logins

Login to the following:

```sh
ente
firefox
google
claude (app + claude code)
GitHub (browser + gh + IG)
Discord
```
