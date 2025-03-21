# Setup

## Auto-mount Drives

Find drive's UUID and type

```sh
lsblk -o NAME,FSTYPE,SIZE,UUID,MOUNTPOINTS
```

Create entries in **`fstab`**

```sh
sudo nano /etc/fstab
```

```sh
<file-system> <mount-point> <type> <options> <dump> <pass>
UUID=<UUID> /media/<user>/<label> <FSTYPE> defaults 0 0

# example
UUID=<UUID> /media/jaime/ssd-store ext4 defaults 0 0
```

Test **`fstab`** configuration:

```sh
sudo findmnt --verify
```

Should output with:

```
Success, no errors or warnings detected
```

Restart:

```sh
sudo reboot now
```

## Increase File Watch Size Limit

View current configuration:

```sh
sysctl fs.inotify
```

Open config for modification:

```sh
code /etc/sysctl.conf
```

Set the following values at the bottom of the config file:

```sh
fs.inotify.max_queued_events = 65536
fs.inotify.max_user_instances=524288
fs.inotify.max_user_watches=524288
```

Apply the configuration:

```sh
sudo sysctl -p
```

## Install Fonts From Zip Archives

* [Cascadia Code](https://github.com/microsoft/cascadia-code)
* [Monaspace](https://github.com/githubnext/monaspace)
* [Geist](https://github.com/vercel/geist-font)

```bash
unzip "*.zip" "*.ttf" "*.otf" -d ${HOME}/.fonts

sudo fc-cache -f -v
```

## PKI Support

1. Download the DoD certificates and unzip them:

    > [!IMPORTANT]
    > Search `pkcs` and download the **DoD PKI Only** bundle.

    https://public.cyber.mil/pki-pke/pkipke-document-library/

    ```sh
    unzip unclass-certificates_pkcs7_DoD.zip
    ```

2. Install packages

    ```sh
    sudo apt install -y \
    pcsc-tools \
    libccid \
    libpcsc-perl \
    libpcsclite1 \
    pcscd \
    opensc \
    opensc-pkcs11 \
    vsmartcard-vpcd \
    libnss3-tools
    ```

3. Make sure CAC is inserted and verify the middleware:

    ```sh
    # ctrl+c to escape
    pcsc_scan
    ```

4. Register CAC Card

    ```sh
    pkcs11-register
    ```

5. Install certificates by opening a terminal pointed to the unzipped certifiate directory and executing the following:

    ```sh
    for n in *.p7b; do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n $n -i $n; done
    for n in *.pem; do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n $n -i $n; done
    ```

6. Setup Firefox

    1. Open *Settings* -> *Privacy & Security* -> **View Certificates...**
    2. Under *Authorities*, click **Import...**
    3. Install `Certificates_PKCS7_{version}_DoD.pem.p7b`
    4. Check *Trust this CA to identify websites.* and *Trust this CA to identify email users.*, then click **OK**
    5. Restart Firefox

### Diagnostic Commands

Check daemons:

```sh
sudo systemctl status pcscd.s*
```

Restart daemons:

```sh
sudo systemctl restart pcscd.socket && sudo systemctl restart pcscd.service
```

Query CAC metadata:

```sh
# list readers
opensc-tool -l

# available card drivers
opensc-tool -D
```