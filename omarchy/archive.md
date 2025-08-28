# Archive

The following settings have been archived and are no longer necessary. Simply kept here in the event that they prove useful at a future point...

## iwd Race Condition

To prevent `iwd` from having a race condition with the `iwlwifi` driver load:

```sh
sudo nvim /etc/modules-load.d/iwlwifi.conf

# create with this line:
iwlwifi
```


## System File Limits

Apply File Limits Immediately

```sh
# 1. Increase for current session
ulimit -n 65536

# 2. Make permanent sysctl changes
echo "fs.file-max = 2097152" | sudo tee -a /etc/sysctl.conf
echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# 3. Make permanent system-wide changes
sudo tee /etc/security/limits.d/99-nofile.conf << 'EOF'
* soft nofile 65536
* hard nofile 65536
* soft nproc 65536
* hard nproc 65536
root soft nofile 65536
root hard nofile 65536
EOF

# 4. For systemd services (very important for PipeWire/WirePlumber)
sudo mkdir -p /etc/systemd/system.conf.d/
sudo tee /etc/systemd/system.conf.d/99-limits.conf << 'EOF'
[Manager]
DefaultLimitNOFILE=65536
DefaultLimitNPROC=65536
EOF

sudo mkdir -p /etc/systemd/user.conf.d/
sudo tee /etc/systemd/user.conf.d/99-limits.conf << 'EOF'
[Manager]
DefaultLimitNOFILE=65536
DefaultLimitNPROC=65536
EOF

# 5. Reload systemd
sudo systemctl daemon-reload
systemctl --user daemon-reload

# 6. Test the new limit
ulimit -n
```


