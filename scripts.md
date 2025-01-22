# Scripts

## ANSI Rainbow

```sh
for (( i = 30; i < 38; i++ ));
do
    echo -e "\033[0;"$i"m Normal: (0;$i); \033[1;"$i"m Light: (1;$i)";
done
```

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

## View Only Directories

```bash
ls -l | grep '^d'
```

## Move Files

```bash
mv <files> <dir>

# example
mv ./*.md ./.notes
```

## Install DoD Certificates from Zip Archive

```bash
unzip unclass-certificates_pkcs7_DoD.zip "*.p7b" "*.sha256" "*.pem" -d /etc/ssl/certs
cd /etc/ssl/certs
sudo mv ./certificates_pkcs7_v5_13_dod/* ./
sudo rm -rf certificates_pkcs7_v5_13_dod
```

## Copy Monitor Settings to Login Screen

```bash
sudo cp ~/.config/monitors.xml ~gdm/.config/
```

## Git Commands

```bash
# show global config
git config --list --global

# set a global config variable
git config --global <variable> <value>

# remove a global config variable
git config --global --unset <variable>
```