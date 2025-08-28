# Omarchy Adjustments

## iwd Race Condition

To prevent `iwd` from having a race condition with the `iwlwifi` driver load:

```sh
sudo nvim /etc/modules-load.d/iwlwifi.conf

# create with this line:
iwlwifi
```

## Configure Docker to Work with NVIDIA Container Toolkit

```sh
sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.backup

sudo nvidia-ctk cdi generate --output/etc/cdi/nvidia.yaml

sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "bip": "172.17.0.1/16",
  "dns": [
    "8.8.8.8",
    "8.8.8.4",
    "1.1.1.1"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-file": "5",
    "max-size": "10m"
  },
  "runtimes": {
    "nvidia": {
      "args": [],
      "path": "nvidia-container-runtime"
    }
  },
  "features": {
    "cdi": true
  }
}
EOF

sudo systemctl restart docker
```

Test with CDI:

```sh
docker run --rm --device nvidia.com/gpu=all nvidia/cuda:13.0.0-runtime-ubuntu22.04 nvidia-smi
```

Updated `docker-compose.yml` format:

```yml
services:
  your-service:
    image: your-image
    devices:
      - nvidia.com/gpus=all
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



