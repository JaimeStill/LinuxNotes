# Arch Linux

I've migrated to Omarchy and need to capture some specific things I've had to do to get my system to work correctly.

## System File Limits

```sh
Apply File Limits Immediately

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

## Audio Jack


