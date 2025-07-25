# Install

```sh
# configure Spotify repository
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# configure nushell repository
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list

# update
sudo apt update

# accept licenses where necessary
sudo apt install -y \
  git \
  gstreamer1.0-plugins-bad \
  libsqlite3-dev \
  nushell \
  pandoc \
  software-properties-common \
  software-properties-gtk \
  spotify-client \
  sqlite3 \
  texlive \
  ttf-mscorefonts-installer \
  ubuntu-restricted-extras \
  uuid-runtime \
  vlc \
  wkhtmltopdf \
  xclip

# post install
sudo fc-cache -f -v
```

* [Signal Desktop](https://signal.org/download/#)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-2-step-by-step-installation-instructions)
* [GitHub CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
* [Go](https://go.dev/doc/install)
* [.NET SDK](https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install)
* [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
  * [Post-Installation Steps](https://docs.docker.com/engine/install/linux-postinstall/)
* [Kubernetes](https://kubernetes.io/docs/tasks/tools/)
  * [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
  * [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)
* [NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-downloads)
* [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
  * [Configuration](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#configuration)
* [Volta](https://volta.sh/) - this is an alternative to `nvm` that supports nushell.

## Flatpacks

These applications are installed directly from the COSMIC Store:

* Ente Auth
* GIMP
* Tweaks

## Razer RGB Lighting

Install OpenRazer:

```sh
sudo apt install software-properties-gtk
sudo add-apt-repository ppa:openrazer/stable
sudo apt update
sudo apt install openrazer-meta
```

Add user to the plugdev group:

```sh
sudo gpasswd -a $USER plugdev
```

Install a GUI to manage and tweak options:

```sh
sudo add-apt-repository ppa:polychromatic/stable
sudo apt update
sudo apt install polychromatic
```
