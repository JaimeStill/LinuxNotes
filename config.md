# Configuration

The following document captures strategies concerning configuration.

## Install Fonts From Zip Archives

* [Cascadia Code](https://github.com/microsoft/cascadia-code)
* [Monaspace](https://github.com/githubnext/monaspace)
* [Geist](https://github.com/vercel/geist-font)

```bash
unzip "*.zip" "*.ttf" "*.otf" -d ${HOME}/.fonts

sudo fc-cache -f -v
```

## Git - Recursive Directory Config

The following configuration enables you to establish `git config` settings for any git repository contained within sub-directory (recursive) of the configured directory.

Any of the repositories encountered wtihin `work` below would receive this configuration:

* `~` (Linux) or `$env:USERPROFILE` (Windows)
    * work
        * testing
            * repository-a
        * repository-b

If I want to use a different email address configuration for all of my work-related repositories, I can create a `~/work/.gitconfig_work` file with the following setting:

```conf
[user]
    email = jaime.still@work.com
```

To apply this configuration to all sub-directories (recursive) of `work`, modify `~/.gitconfig` (Linux / MacOS) or `$env:USERPROFILE/.gitconfig` (Windows) with the following:

```conf
# global git config
[user]
    name = Jaime Still
    email = jpstill85@gmail.com

# place at the end of the config
[includeIf "gitdir:~/work/"]
    path = ~/work/.gitconfig_work
```

Running `git config --list` in a repo outside of `~/work` prints:

```
user.email=jpstill85@gmail.com
```

Running `git config --list` in any repository within a sub-directory (recursive) of `~/work` prints:

```
user.email=jaime.still@work.com
```

## Fix Fuzzy Text

Install `gnome-tweaks` and set the following:

* `Fonts/Hinting` - **Full**
* `Fonts/Antialiasing` - **Subpixel (for LCD screens)**

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