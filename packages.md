# Packages

## Neofetch

```bash
sudo apt install neofetch
```

## Firefox

```sh
sudo install -d -m 0755 /etc/apt/keyrings
```

```sh
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
```

```sh
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
```

```sh
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
```

```sh
sudo apt update && sudo apt install firefox
```

## Spotify

```bash
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-get update && sudo apt-get install spotify-client
```

## Signal

```bash
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list

sudo apt update && sudo apt install signal-desktop
```

## Synaptic Package Manager

```
sudo apt install synaptic
```

## Git

```bash
sudo apt install git software-properties-common -y
```

## Ubuntu Cleaner

```bash
sudo add-apt-repository ppa:gerardpuig/ppa
sudo apt update -y
sudo apt install ubuntu-cleaner
```

## Cosmic Packages

```bash
sudo apt install cosmic-edit \
  cosmic-icons \
  cosmic-store \
  cosmic-term
```

## Azure CLI

```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources

sudo apt update
sudo apt install azure-cli
```

## PowerShell

```bash
###################################
# Prerequisites

# Update the list of packages
sudo apt-get update

# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common

# Get the version of Ubuntu
source /etc/os-release

# Download the Microsoft repository keys
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb

# Delete the Microsoft repository keys file
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
sudo apt-get update

###################################
# Install PowerShell
sudo apt-get install -y powershell

# Start PowerShell
pwsh
```

## .NET SDK

```bash
sudo apt install -y dotnet-sdk-8.0 \
  aspnetcore-runtime-8.0
```

## Docker

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Download the latest [DEB package](https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64&_gl=1*g6ux04*_ga*MTc2MDk2ODQ5Mi4xNzI2MjU4NzU0*_ga_XJWPQMJYHQ*MTcyNjI1ODc1My4xLjEuMTcyNjI1ODc3Ny4zNi4wLjA.) (see [Release notes](https://docs.docker.com/desktop/release-notes/)).

```bash
# install Docker Desktop
sudo apt install ./docker-desktop-<arch>.deb
```

## Azure Data Studio

Download the [.deb](https://azuredatastudio-update.azurewebsites.net/latest/linux-deb-x64/stable) file.

```bash
sudo dpkg -i ./azuredatastudio-linux-1.49.1.deb
```

## GitHub CLI

**Install**

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
```

**Upgrade**

```bash
sudo apt update
sudo apt install gh
```

## Gnome Tweaks

```bash
sudo apt install gnome-tweaks
```

## Guake

Press <kbd>F12</kbd> to open guake terminal.

```bash
sudo add-apt-repository ppa:linuxuprising/guake
sudo apt update

sudo apt install guake
```

## Microsoft Fonts

```bash
sudo apt install ttf-mscorefonts-installer
sudo fc-cache -f -v
```

## Pandoc

```sh
sudo apt install pandoc texlive wkhtmltopdf -y
```

### Markdown to PDF with Styling

```sh
# replace input and output with file names
pandoc -t html --css ~/github.css <input>.md -o <output>.pdf --pdf-engine-opt=--enable-local-file-access --metadata title="Git Setup"
```

## Node.js

```sh
# install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# download and install Node.js
nvm install 20

# verify the right Node.js version
node -v

# verify the right npm version
npm -v
```

## Deno 2

```sh
curl -fsSL https://deno.land/install.sh | sh
```

### Enable Completions

```sh
# create if bash_completions.d does not exist
sudo mkdir /usr/local/etc/bash_completions.d

# grant permissions
sudo chmod 777 /usr/local/etc/bash_completions.d/

# output bash completions setup
deno completions bash > /usr/local/etc/bash_completions.d/deno.bash

# source deno completions
source /usr/local/etc/bash_completions.d/deno.bash
```

## Remove Pop Shop

```sh
sudo apt remove pop-shop
```