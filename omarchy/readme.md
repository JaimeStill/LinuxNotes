# [Omarchy](https://omarchy.org/)

Install according to [Getting Started](https://learn.omacom.io/2/the-omarchy-manual/50/getting-started).

Be sure to follow each section in sequence as they are listed in order of dependency.

## Applications

### Packages

> [!TIP]
> When configuring packages through the Omarchy installer, you can use <kdb>Tab</kdb> to stage multiple packages vs. having to install / remove one at a time.

Install the following packages (<kbd>Super+Alt+Space</kbd> -> Install -> Package):

```sh
appgate-sdp
azure-cli
caligula
ccid
firefox
libappindicator-gtk3
nvidia-container-toolkit
opensc
otf-geist-mono-nerd
pcsclite
visual-studio-code-bin
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

`ghostty/config`

```sh
# Dynamic theme colors
config-file = ?"~/.config/omarchy/current/theme/ghostty.conf"

# Font
font-family = "Cascadia Code NF"
font-style = Regular
font-size = 11
font-feature = +calt

# Window
window-padding-x = 14
window-padding-y = 14
confirm-close-surface=false
resize-overlay = never
window-inherit-working-directory = true

# Cursor stlying
cursor-style = "block"
cursor-style-blink = false
shell-integration-features = no-cursor

# Keyboard bindings
keybind = f11=toggle_fullscreen
keybind = shift+insert=paste_from_clipboard
keybind = control+insert=copy_to_clipboard
keybind = shift+enter=text:\n
keybind = ctrl+equal=increase_font_size:1
keybind = ctrl+minus=decrease_font_size:1
keybind = ctrl+0=reset_font_size
```

`hypr/bindings.conf`

Hyprland keyboard shortcuts

```sh
# Application bindings
$terminal = uwsm app -- $TERMINAL
$browser = omarchy-launch-browser

bindd = SUPER, RETURN, Terminal, exec, $terminal
bindd = SUPER SHIFT, F, File manager, exec, uwsm app -- nautilus --new-window
bindd = SUPER SHIFT, B, Browser, exec, uwsm app -- firefox
bindd = SUPER SHIFT, M, Music, exec, omarchy-launch-or-focus spotify
bindd = SUPER SHIFT, N, Editor, exec, omarchy-launch-editor
bindd = SUPER SHIFT, T, Activity, exec, $terminal -e btop
bindd = SUPER SHIFT, D, Docker, exec, $terminal -e lazydocker
bindd = SUPER SHIFT, G, Signal, exec, omarchy-launch-or-focus signal "uwsm app -- signal-desktop"
bindd = SUPER SHIFT, slash, Passwords, exec, uwsm app -- enteauth

# If your web app url contains #, type it as ## to prevent hyperland treat it as comments
bindd = SUPER SHIFT, A, Claude, exec, omarchy-launch-webapp "https://claude.ai"
bindd = SUPER SHIFT, E, Gmail, exec, omarchy-launch-webapp "https://gmail.com"
bindd = SUPER SHIFT, Y, YouTube, exec, omarchy-launch-webapp "https://youtube.com/"

# Overwrite existing bindings, like putting Omarchy Menu on Super + Space
# unbind = SUPER SHIFT, Space
# bindd = SUPER SHIFT, SPACE, Omarchy menu, exec, omarchy-menu
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

Set relative line numbers + disable automatically generating comments on newline when writing comments.

```lua
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])
```

`nvim/lua/plugins/completions.lua`

Remove non-LSP suggestions from the completions list.

```lua
return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      default = { "lsp" },
      transform_items = function(_, items)
        return vim.tbl_filter(function(item)
          local kind = require("blink.cmp.types").CompletionItemKind[item.kind]
          return kind ~= "Text" and kind ~= "Snippet" and kind ~= "Macro"
        end, items)
      end,
    },
  },
}
```

`nvim/lua/plugins/disabled.lua`

Disable mini AI features.

```lua
return {
  {
    "nvim-mini/mini.ai",
    enabled = false,
  },
}
```

`nvim/lua/plugins/lsp.lua`

Disable concealing symbols in markdown files.

```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.conceallevel = 0
        end,
      })
    end,
  },
}
```

`nvim/lua/plugins/pairs.lua`

Disable pairs for single quote and grave accent.

```lua
return {
  "nvim-mini/mini.pairs",
  opts = {
    mappings = {
      ["'"] = false,
      ["`"] = false,
    },
  },
}
```

## Fix Laptop Screen Recording

The following configuration is required for `omarchy-bin-screenrecord` to function properly on my Dell XPS 16 laptop.

```sh
yay -Syu intel-media-driver libva-utils
```

Modify `~/.bashrc`:

```sh
export LIBVA_DRIVER_NAME=iHD
```

## VS Code Keyring

VS Code with the SQL Server extension is currently the best option for interfacing with SQL containers, so for now it will have to be installed.

To avoid issues with keyring storage, add the following setting to the end of `~/.vscode/argv.json`:

```json
{
  /* other configuration */
  "password-store": "gnome-libsecret"
}
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

## Appgate SDP VPN Configuration

The following adjustments are necessary to enable the VPN client to function correctly on Arch Linux:

1. Make `tun` persistent:

  ```sh
  echo `tun` | sudo tee /etc/modules-load.d/tun.conf
  ```

2. Create a dedicated IP forwarding config:

  ```sh
  echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-appgate.conf
  ```

3. Set network capabilities:

  ```sh
  # set service capabilities
  sudo setcap cap_net_admin,cap_net_raw+ep "/opt/appgate/service/Appgate Service"

  # set driver capabilities
  sudo setcap cap_net_admin,cap_net_raw+ep /opt/appgate/appgate-driver

  # verify
  getcap "/opt/appgate/service/Appgate Service"
  getcap /opt/appgate/appgate-driver
  ```

4. Start and enable the appgate driver service:

  ```sh
  sudo systemctl start appgatedriver.service
  sudo systemctl enable appgatedriver.service
  ```

If it's running, quit and restart appgate SDP and you should have access to your sites.
