# Arch Linux Audio Issues - Dell XPS 16 9640

## System Information
- **Laptop**: Dell XPS 16 (9640)
- **Kernel**: Linux 6.16.3-arch1-1
- **Audio Setup**: 
  - SOF Soundwire (sof-soundwire)
  - CS42L43 codec for headphone/microphone jack
  - CS35L56 amplifiers (4x) for speakers
  - Intel Meteor Lake-P HD Audio Controller

## Issues Identified

### 1. WiFi Card Issues ✅ FIXED
- **Problem**: iwd service failing with "Too many open files in system"
- **Solution**: Increased system file limits in `/etc/security/limits.d/99-nofile.conf`

### 2. Headphone Jack Not Working 🔧 IN PROGRESS
- **Problem**: No separate PCM device for headphones; shares PCM 1,2 with speakers
- **Root Cause**: 
  - CS42L43 codec handles headphone routing but audio still plays through CS35L56 speaker amps
  - No automatic jack detection switching
  - UCM configuration incomplete (missing HiFi profile)

### 3. Spotify Wayland Scaling Issues 📝 TODO
- **Problem**: With Wayland flags, Spotify takes minutes to open. Without flags, app is scaled 250%
- **Suspected Cause**: GPU selection issue (Intel Arc vs NVIDIA RTX 4070)

## Audio Hardware Details

### Audio Devices
```
Card 1: sof-soundwire
  Device 2: Speaker (plughw:1,2)
  Device 4: Microphone capture
  Device 5-7: HDMI outputs
```

### Codec Routing
- **CS42L43** (Headphone/Mic codec):
  - Input options: ASPRX1-6, DP5RX1-2, DP6RX1-2, DP7RX1-2
  - Controls headphone routing matrix
  - Jack Override control (locked by kernel)

- **CS35L56** (Speaker amplifiers):
  - 4 separate amplifiers (AMP1-4)
  - Independent control from CS42L43
  - Controls: `AMP[1-4] Speaker Switch`, `Speaker Switch`

## Current Findings

### Working Audio Paths
- **Speakers**: 
  - ASPRX1/2 → CS42L43 Speaker inputs (works but bypassed)
  - DP5RX1/2 → CS42L43 Speaker inputs (works but bypassed)
  - Actually controlled by CS35L56 amps directly

### Headphone Routing Attempts
1. CS42L43 routing configured but audio still plays through speakers
2. Disabling CS42L43 speaker routing has no effect
3. CS35L56 amplifiers need to be disabled for headphones to work

## Scripts Created

### ~/audio-headphones.sh
```bash
#!/bin/bash
echo "Switching to headphones..."

# Disable CS35L56 speaker amplifiers
amixer -c1 sset 'AMP1 Speaker Switch' off 2>/dev/null
amixer -c1 sset 'AMP2 Speaker Switch' off 2>/dev/null
amixer -c1 sset 'AMP3 Speaker Switch' off 2>/dev/null
amixer -c1 sset 'AMP4 Speaker Switch' off 2>/dev/null
amixer -c1 sset 'Speaker Switch' off 2>/dev/null

# Enable headphone routing
amixer -c1 cset name='cs42l43 Headphone L Input 1' 7 2>/dev/null  # ASPRX1
amixer -c1 cset name='cs42l43 Headphone R Input 1' 8 2>/dev/null  # ASPRX2
amixer -c1 cset name='cs42l43 Headphone Digital Volume' 100 2>/dev/null

echo "Headphones enabled"
```

### ~/audio-speakers.sh
```bash
#!/bin/bash
echo "Switching to speakers..."

# Disable headphones
amixer -c1 cset name='cs42l43 Headphone L Input 1' 0 2>/dev/null
amixer -c1 cset name='cs42l43 Headphone R Input 1' 0 2>/dev/null

# Enable CS35L56 speaker amplifiers
amixer -c1 sset 'AMP1 Speaker Switch' on 2>/dev/null
amixer -c1 sset 'AMP2 Speaker Switch' on 2>/dev/null
amixer -c1 sset 'AMP3 Speaker Switch' on 2>/dev/null
amixer -c1 sset 'AMP4 Speaker Switch' on 2>/dev/null
amixer -c1 sset 'Speaker Switch' on 2>/dev/null
amixer -c1 sset 'Speaker' 50% 2>/dev/null

echo "Speakers enabled"
```

## Next Steps to Test

1. **Test headphone output** with CS35L56 amps disabled:
   ```bash
   ~/audio-headphones.sh
   speaker-test -D plughw:1,2 -c 2 -t sine -f 440 -l 2
   ```

2. **If headphones work**, make settings persistent:
   - Save ALSA state: `sudo alsactl store 1`
   - Create systemd service for automatic switching
   - Investigate jack detection for automatic switching

3. **Fix Spotify Wayland scaling**:
   - Force Intel Arc GPU for Spotify
   - Test different Wayland flags
   - Consider environment variables for scaling

## Useful Commands for Debugging

```bash
# Check current audio routing
amixer -c1 cget name='cs42l43 Headphone L Input 1' | grep ": values"
amixer -c1 cget name='cs42l43 Speaker L Input 1' | grep ": values"

# Check amplifier states
amixer -c1 sget 'AMP1 Speaker Switch'
amixer -c1 sget 'Speaker Switch'

# Monitor jack detection (if working)
alsactl monitor

# Test audio output
speaker-test -D plughw:1,2 -c 2 -t sine -f 440 -l 1
paplay /usr/share/sounds/alsa/Front_Center.wav
```

## References
- [Arch Wiki - Dell XPS 16 9640](https://wiki.archlinux.org/title/Dell_XPS_16_(9640))
- SOF Project documentation
- ALSA CS42L43/CS35L56 codec documentation

## Debug Log
