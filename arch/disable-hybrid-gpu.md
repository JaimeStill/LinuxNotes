# NVIDIA-Only GPU Configuration Guide for Dell XPS 16 9640

## Current System Status
- **GPUs**: Intel Arc Graphics + NVIDIA RTX 4070 Mobile
- **Display Server**: Wayland (Hyprland)
- **Current Setup**: Hybrid graphics with Intel as primary
- **NVIDIA Driver**: 580.76.05

## Implementation Guide

### Step 1: Update Kernel Boot Parameters

Edit your systemd-boot configuration file:
```bash
sudo nano /boot/loader/entries/2025-08-25_13-52-04_linux.conf
```

Add these parameters to the `options` line:
```
module_blacklist=i915,xe nvidia-drm.modeset=1 nvidia-drm.fbdev=1
```

Your options line should look like:
```
options cryptdevice=PARTUUID=4e9773c6-dc65-4497-ab11-b99e3a905de7:root root=/dev/mapper/root zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs module_blacklist=i915,xe nvidia-drm.modeset=1 nvidia-drm.fbdev=1 splash quiet
```

Also update the fallback configuration:
```bash
sudo nano /boot/loader/entries/2025-08-25_13-52-04_linux-fallback.conf
```

### Step 2: Create Intel GPU Blacklist Configuration

Create a new modprobe configuration to prevent Intel GPU modules from loading:
```bash
sudo nano /etc/modprobe.d/blacklist-intel.conf
```

Add:
```
blacklist i915
blacklist xe
install i915 /bin/false
install xe /bin/false
```

### Step 3: Update NVIDIA Module Configuration

Edit the existing NVIDIA configuration:
```bash
sudo nano /etc/modprobe.d/nvidia.conf
```

Replace the content with:
```
options nvidia_drm modeset=1 fbdev=1
options nvidia NVreg_UsePageAttributeTable=1
options nvidia NVreg_PreserveVideoMemoryAllocations=1
```

### Step 4: Configure Hyprland Environment Variables

Edit your Hyprland configuration:
```bash
nano ~/.config/hypr/hyprland.conf
```

Add or update these environment variables:
```
# NVIDIA GPU Configuration
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __NV_PRIME_RENDER_OFFLOAD,1
env = __VK_LAYER_NV_optimus,NVIDIA_only
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_DRM_DEVICES,/dev/dri/card1
env = WLR_DRM_NO_ATOMIC,1
env = XCURSOR_SIZE,24
env = MOZ_ENABLE_WAYLAND,1
env = ELECTRON_OZONE_PLATFORM_HINT,wayland
```

### Step 5: Create Xorg Configuration (for XWayland)

Create an Xorg configuration for NVIDIA:
```bash
sudo nano /etc/X11/xorg.conf.d/10-nvidia.conf
```

Add:
```
Section "ServerLayout"
    Identifier "layout"
    Option "AllowNVIDIAGPUScreens"
EndSection

Section "Device"
    Identifier "nvidia"
    Driver "nvidia"
    BusID "PCI:1:0:0"
    Option "PrimaryGPU" "yes"
EndSection

Section "Screen"
    Identifier "nvidia"
    Device "nvidia"
EndSection
```

### Step 6: Update mkinitcpio (if needed)

Edit mkinitcpio configuration:
```bash
sudo nano /etc/mkinitcpio.conf
```

Ensure MODULES includes:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Regenerate initramfs:
```bash
sudo mkinitcpio -P
```

### Step 7: Create Application Launch Scripts (Optional)

For problematic applications, create wrapper scripts:

```bash
nano ~/.local/bin/spotify-nvidia
```

Add:
```bash
#!/bin/bash
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
exec spotify "$@"
```

Make it executable:
```bash
chmod +x ~/.local/bin/spotify-nvidia
```

### Step 8: Reboot and Verify

1. **Reboot your system**
2. **Verify Intel GPU is disabled**:
   ```bash
   lsmod | grep i915  # Should return nothing
   lsmod | grep xe   # Should return nothing
   ```

3. **Verify NVIDIA is primary**:
   ```bash
   nvidia-smi  # Should show GPU is being used
   cat /sys/class/graphics/fb0/device/uevent | grep DRIVER  # Should show nvidia
   ```

## Troubleshooting

### If system won't boot:
1. At boot menu, press `e` to edit boot parameters
2. Remove `module_blacklist=i915,xe` temporarily
3. Boot and revert changes

### If Wayland apps still have issues:
Try launching with:
```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia application_name
```

### Power Management Note:
With Intel GPU disabled:
- Battery life will be significantly reduced
- Laptop will run warmer
- Fan may run more frequently

Consider using `nvidia-powerd` service:
```bash
sudo systemctl enable nvidia-powerd
sudo systemctl start nvidia-powerd
```

## Reverting Changes

To re-enable hybrid graphics:
1. Remove `module_blacklist=i915,xe` from boot parameters
2. Delete `/etc/modprobe.d/blacklist-intel.conf`
3. Remove NVIDIA-specific environment variables from Hyprland config
4. Reboot

## Additional Resources
- [NVIDIA Wayland Documentation](https://wiki.archlinux.org/title/NVIDIA#Wayland)
- [Hyprland NVIDIA Guide](https://wiki.hyprland.org/Nvidia/)
- [Arch Wiki - PRIME](https://wiki.archlinux.org/title/PRIME)