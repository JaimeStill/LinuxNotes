# [Omarchy](https://omarchy.org/)

Install according to [Getting Started](https://learn.omacom.io/2/the-omarchy-manual/50/getting-started).

Be sure to follow each section in sequence as they are listed in order of dependency.

## Applications

### Packages

> [!TIP]
> When configuring packages through the Omarchy installer, you can use <kdb>Tab</kdb> to stage multiple packages vs. having to install / remove one at a time.

Install the following packages (<kbd>Super+Alt+Space</kbd> -> Install -> Package):

```sh
azure-cli
caligula
ccid
firefox
nvidia-container-toolkit
opensc
otf-geist-mono-nerd
pcsclite
```

Install the following AUR package (<kbd>Super+Alt+Space</kbd> -> Install -> AUR):

```sh
ente-auth-bin
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
bindd = SUPER, slash, Passwords, exec, uwsm app -- enteauth

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

**Laptop**

```sh
# See https://wiki.hyprland.org/Configuring/Monitors/
# List current monitors and resolutions possible: hyprctl monitors
# Format: monitor = [port], resolution, position, scale
# You must relaunch Hyprland after changing any envs (use Super+Esc, then Relaunch)

env = GDK_SCALE,1
monitor=,preferred,auto,auto
monitor=DP-7,3440x1440@99.98Hz,auto-left,auto

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

`waybar/style.css`

```css
@import "../omarchy/current/theme/waybar.css";

* {
  background-color: @background;
  color: @foreground;

  border: none;
  border-radius: 0;
  min-height: 0;
  font-family: 'GeistMono Nerd Font';
  font-size: 14px;
}

.modules-left {
  margin-left: 8px;
}

.modules-right {
  margin-right: 8px;
}

#workspaces button {
  all: initial;
  padding: 0 6px;
  margin: 0 1.5px;
  min-width: 9px;
}

#workspaces button.empty {
  opacity: 0.5;
}

#tray,
#cpu,
#battery,
#network,
#bluetooth,
#pulseaudio,
#custom-omarchy,
#custom-update {
  min-width: 12px;
  margin: 0 7.5px;
}

#custom-expand-icon {
  margin-right: 7px;
}

tooltip {
  padding: 2px;
}

#custom-update {
  font-size: 10px;
}

#clock {
  margin-left: 8.75px;
}

.hidden {
  opacity: 0;
}
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

## iwd Race Condition

To prevent `iwd` from having a race condition with the `iwlwifi` driver load:

```sh
sudo nvim /etc/modules-load.d/iwlwifi.conf

# create with this line:
iwlwifi

# restart iwd daemon if currently fixing
sudo systemctl restart iwd
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

## CAC Setup

> [!NOTE]
> See [Arch Wiki - Common Access Card](https://wiki.archlinux.org/title/Common_Access_Card) for full details.
> 
> Required packages were already installed above.

Navigate to [Cyber PKI Library](https://www.cyber.mil/pki-pke/document-library) and download *PKI CA Certificate Bundles: PKCS#7 for DoD PKI Only*.

```sh
# setup the pcscd daemon
sudo systemctl start pcscd.socket
sudo systemctl enable pcscd.socket

# unzip PKCS cert bundle
unzip ~/Downloads/unclass-certificates_pkcs7_DoD.zip
```

### Firefox

1. In Settings: Preferences -> Privacy & Security -> Certificates -> Security Devices.
2. Click Load and configure as follows:

    ```sh
    CAC Module
    /usr/lib/opensc-pkcs11.so
    ```
3. In Settings: Preferences -> Privacy & Security -> Certificates -> View Certificates.
4. Install the unzipped certificates, in the order presented, by going to Authorities -> Import:

  ```sh
  Certificates_PKCS7_[version]_DoD_der.p7b
  Certificates_PKCS7_[version]_DoD.pem.p7b
  ```

### Chromium

> [!IMPORTANT]
> It's critical that Chromium /  Chrome are closed and your CAC is connected when executing these steps!

```sh
# add CAC Module to NSS DB
modutil -dbdir sql:$HOME/.pki/nssdb/ -add "CAC Module" -libfile /usr/lib/opensc-pkcs11.so

# verify CAC Module was successfully added
modutil -dbdir sql:$HOME/.pki/nssdb/ -list

# cd to unzip location
cd ~/Downloads/Certificates_PKCS7_[verson]_DoD/

# install certificates
for n in *der.p7b; do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n $n -i $n; done

# cleanup files
rm -f ~/Downloads/unclass-certificates_pkcs7_DoD.zip
rm -rf ~/Downloads/Certificates_PKCS7_[version]_DoD
```

## Logins

Login to the following (in this order):

```sh
Ente Auth
Google
Firefox
GitHub (browser + gh + IG)
Claude (app + claude code)
az cli (comm + gov)
```

For Azure CLI:

```sh
# login with tenant ID specified.
# can be obtained by navigating to Entra.
az login --tenant [TenantID]

# switch cloud to login to a different account.
az cloud set -n [AzureCloud|AzureUSGovernment]
```

## Bash

```sh
alias az-cloud='az cloud set -n AzureCloud'
alias az-gov='az cloud set -n AzureUSGovernment'
alias az-gov-test='az account set -n s2va-gov-test'
alias az-gov-ss='az account set -n s2va-gov-sharedservices'
```
