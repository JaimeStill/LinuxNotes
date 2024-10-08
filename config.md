# Configuration

The following document captures strategies concerning configuration.

## [Install Cosmic Epoch](https://github.com/pop-os/cosmic-epoch?tab=readme-ov-file#installing-on-pop_os)

1. Enable Wayland

    ```sh
    sudo nano /etc/gdm3/custom.conf
    ```

2. Change `WaylandEnable` to `true`

    ```conf
    WaylandEnable=true
    ```

3. Reboot for the change to take effect

4. Update `udev` rules for NVIDIA users

    ```sh
    sudo nano /usr/lib/udev/rules.d/61-gdm.rules
    ```

5. Look for `LABEL="gdm_prefer_xorg"` and `LABEL="gdm_disable_wayland"`. Add `#` to the `RUN` statements so they look like this:

    ```conf
    LABEL="gdm_prefer_xorg"
    #RUN+="/usr/libexec/gdm-runtime-config set daemon PreferredDisplayServer xorg"
    GOTO="gdm_end"

    LABEL="gdm_disable_wayland"
    #RUN+="/usr/libexec/gdm-runtime-config set daemon WaylandEnable false"
    GOTO="gdm_end"
    ```

6. Restart gdm

    ```sh
    sudo systemctl restart gdm
    ```

7. Install COSMIC

    ```sh
    sudo apt install cosmic-session
    ```

After logging out, click on your user and there will be a sprocket at the bottom right. Change the setting to COSMIC. Proceed to log in.

## Initialize `pass`

1. Generate a GPG key

    ```bash
    gpg --generate-key
    ```

    **Output**

    ```
    gpg (GnuPG) 2.2.27; Copyright (C) 2021 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    gpg: directory '/home/jaime/.gnupg' created
    gpg: keybox '/home/jaime/.gnupg/pubring.kbx' created
    Note: Use "gpg --full-generate-key" for a full featured key generation dialog.

    GnuPG needs to construct a user ID to identify your key.

    Real name: Jaime Still
    Email address: jpstill85@gmail.com
    You selected this USER-ID:
        "Jaime Still <jpstill85@gmail.com>"

    Change (N)ame, (E)mail, or (O)kay/(Q)uit? O
    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    gpg: /home/jaime/.gnupg/trustdb.gpg: trustdb created
    gpg: key DDA5D6A70FB57BD2 marked as ultimately trusted
    gpg: directory '/home/jaime/.gnupg/openpgp-revocs.d' created
    gpg: revocation certificate stored as '/home/jaime/.gnupg/openpgp-revocs.d/DFED41698758C8C15C9634D0DDA5D6A70FB57BD2.rev'
    public and secret key created and signed.

    pub   rsa3072 2024-10-03 [SC] [expires: 2026-10-03]
        DFED41698758C8C15C9634D0DDA5D6A70FB57BD2
    uid                      Jaime Still <jpstill85@gmail.com>
    sub   rsa3072 2024-10-03 [E] [expires: 2026-10-03]
    ```

2. Initialize pass with generated public key, `DFED41698758C8C15C9634D0DDA5D6A70FB57BD2`:

    ```bash
    pass init DFED41698758C8C15C9634D0DDA5D6A70FB57BD2
    ```

    **Output**

    ```
    mkdir: created directory '/home/jaime/.password-store/'
    Password store initialized for DFED41698758C8C15C9634D0DDA5D6A70FB57BD2
    ```

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