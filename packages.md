# Packages

## Neofetch

```bash
sudo apt install neofetch
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

## Azure data Studio

Download the [.deb](https://azuredatastudio-update.azurewebsites.net/latest/linux-deb-x64/stable) file.

```bash
sudo dpkg -i ./azuredatastudio-linux-1.49.1.deb
```

## Smart Card

```bash
sudo apt install \
  pcsc-tools \
  libccid \
  libpcsc-perl \
  libpcsclite1 \
  pcscd \
  opensc \
  opensc-pkcs11 \
  vsmartcard-vpcd \
  libnss3-tools \
  -y
```

### Verify CAC Middleware

```bash
pcsc_scan
```

### Check and Restart PCSCD Daemon

```bash
# view daemon
sudo systemctl status pcscd.s*

# restart
sudo systemctl restart pcscd.socket && sudo systemctl restart pcscd.service
```

### Free Up USB

Run if you get the following message from `pcsc_scan`: "scanning present readers waiting for the first reader..."

```bash
modprobe -r pn533 nfc
```

### Query CAC Metadata

```bash
# list readers
opensc-tool -l

# available card drivers
opensc-tool -D
```

### Browser Configuration

Download the DoD certificates and unzip them:

> search `pkcs` and download the **DoD PKI Only** bundle.

https://public.cyber.mil/pki-pke/pkipke-document-library/

```bash
unzip unclass-certificates_pkcs7_DoD.zip
```

### Register CAC Card

```bash
pkcs11-register
```

#### Firefox

1. Open *Settings*, search *Certificates* and click *View Certificates*
2. Click **Import...***
3. Install `certificates_pkcs7_V5_13_dod_der.p7b`
4. Check **Trust this CA to identify websites.** and **Trust this CA to identify email users.**, then click **OK**.
5. Restart **Firefox**.

#### Edge

Query nssdb to see if the OpenSC framework was registered in the NSS DB by using `pkcs11-register`:

```bash
modutil -dbdir sql:$HOME/.pki/nssdb/ -list
```

Add the DoD Certificates to nssdb from the directory of the unzipped DoD Certificates:

> You will have to enter your CAC pin for each command below

```bash
for n in *.p7b; do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n $n -i $n; done
for n in *.pem; do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n $n -i $n; done
```

Verify authorities in *Settings* > *Privacy, search, and services* > *Manage certificates*. You should see **U.S. Government** under *Your certificates* and *Authorities*.