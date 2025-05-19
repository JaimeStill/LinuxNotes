# Scripts

## Firmware Update

```sh
fwupdmgr refresh --force \
    && fwupdmgr get-updates \
    && fwupdmgr update
```

## Fix Lingering Compositor Output Configuration

This occurs when you shutdown a laptop with an external monitor connected as the primary display, then boot your laptop with the monitor no longer connected. Running this command from a different TTY session (`ctrl + alt + F2`) will allow you to reload the greeter and start a session with the proper display settings:

```sh
rm ~/.local/state/cosmic-comp/outputs.ron
```

## Trim Video

```sh
ffmpeg -ss <hh:mm:ss> -to <hh:mm:ss> -i <input-video> -c copy <output-video>
```

## Uninstall `nvm`

```sh
rm -rf ~/$NVM_DIR
```

Remove the following lines from `~/.bashrc`:

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

## Recover Failed Service

```sh
systemctl reset-failed <service>
```

## Change Azure CLI Account

```sh
az account set -n <sub-name>
```

## Markdown to PDF with Styling

```sh
# replace input and output with file names
pandoc -t html --css ~/github.css <input>.md -o <output>.pdf --pdf-engine-opt=--enable-local-file-access --metadata title="Git Setup"
```

## ANSI Rainbow

```sh
for (( i = 30; i < 38; i++ ));
do
    echo -e "\033[0;"$i"m Normal: (0;$i); \033[1;"$i"m Light: (1;$i)";
done
```

## View Only Directories

```bash
ls -l | grep '^d'
```

## Copy Monitor Settings to Login Screen

```bash
sudo cp ~/.config/monitors.xml ~gdm/.config/
```

## Change Default Terminal

```bash
sudo update-alternatives --config x-terminal-emulator
```

## Strip newlines from **`xclip`**

Open **`~/.bashrc`** and add the following:

```sh
# Alias to strip newline from xclip
alias xclip='xargs echo -n | xclip -selection clipboard'
```

Usage:

```sh
uuidgen | xclip
```

Allows you to paste the results without it appending a newline.

## Apt

### View Installed Packages

```bash
# view installed packages
apt list --installed

# search installed packages
apt list --installed | grep <search>
```

### Search for Apt Packages

```bash
# find a specific package
apt-cache search <keyword>

# show all packages
apt-cache search .
```

### Update, Upgrade, and Autoremove Apt

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```

### Fix Locked Dpkg

```bash
sudo killall apt apt-get
```

## Fixes

The sections below indicate how to fix encountered issues.

### Screen Going Blank After 30 Seconds

[Source](https://www.reddit.com/r/pop_os/comments/eln8bp/screen_going_black_after_30_seconds/)

```bash
xset -dpms
```

### Clean Firefox

```bash
sudo rm -rf /usr/lib/firefox/
rm -rf ~/.var/app/org.mozilla.firefox/
```

### Broken Suspend

[Source](https://github.com/pop-os/pop/issues/449#issuecomment-502746351)

```bash
sudo kernelstub -a mem_sleep_default=deep
```

### Fix NTFS Drive Access

```sh
sudo ntfsfix /dev/"device name"
```