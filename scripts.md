# Scripts

## Firmware Update

```sh
fwupdmgr refresh --force \
    && fwupdmgr get-updates \
    && fwupdmgr update
```

## Trim Video

```sh
ffmpeg -ss <hh:mm:ss> -to <hh:mm:ss> -i <input-video> -c copy <output-video>
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