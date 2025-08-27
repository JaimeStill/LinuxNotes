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

# Arch Linux

I've migrated to Omarchy and need to capture some specific things I've had to do to get my system to work correctly.

## Sound Card Misconfiguration

### Phase 1 - Diagnostics

Let's try:

```sh
amixer -c2 cget name='cs42l43 Headphone L Input 1'
```

Also, let's check what the current headphone routing values are:

```sh
amixer -c2 cget name='cs42l43 Headphone L Input 1' | grep ": values"
amixer -c2 cget name='cs42l43 Headphone R Input 1' | grep ": values"
```

And let's see what input options are available by checking the control info:

```sh
amixer -c2 cget name='cs42l43 Headphone L Input 1'
```

This should show us the available input routing options (like 'None', 'ASPRX1', 'ASPRX2', etc.).

```sh
> amixer -c2 cget name='cs42l43 Headphone L Input 1'
numid=163,iface=MIXER,name='cs42l43 Headphone L Input 1'
  ; type=ENUMERATED,access=rw------,values=1,items=37
  ; Item #0 'None'
  ; Item #1 'Tone Generator 1'
  ; Item #2 'Tone Generator 2'
  ; Item #3 'Decimator 1'
  ; Item #4 'Decimator 2'
  ; Item #5 'Decimator 3'
  ; Item #6 'Decimator 4'
  ; Item #7 'ASPRX1'
  ; Item #8 'ASPRX2'
  ; Item #9 'ASPRX3'
  ; Item #10 'ASPRX4'
  ; Item #11 'ASPRX5'
  ; Item #12 'ASPRX6'
  ; Item #13 'DP5RX1'
  ; Item #14 'DP5RX2'
  ; Item #15 'DP6RX1'
  ; Item #16 'DP6RX2'
  ; Item #17 'DP7RX1'
  ; Item #18 'DP7RX2'
  ; Item #19 'ASRC INT1'
  ; Item #20 'ASRC INT2'
  ; Item #21 'ASRC INT3'
  ; Item #22 'ASRC INT4'
  ; Item #23 'ASRC DEC1'
  ; Item #24 'ASRC DEC2'
  ; Item #25 'ASRC DEC3'
  ; Item #26 'ASRC DEC4'
  ; Item #27 'ISRC1 INT1'
  ; Item #28 'ISRC1 INT2'
  ; Item #29 'ISRC1 DEC1'
  ; Item #30 'ISRC1 DEC2'
  ; Item #31 'ISRC2 INT1'
  ; Item #32 'ISRC2 INT2'
  ; Item #33 'ISRC2 DEC1'
  ; Item #34 'ISRC2 DEC2'
  ; Item #35 'EQ1'
  ; Item #36 'EQ2'
  : values=0


LinuxNotes main ? ❯   amixer -c2 cget name='cs42l43 Headphone L Input 1' | grep ": values"
  : values=0

LinuxNotes main ? ❯   amixer -c2 cget name='cs42l43 Headphone R Input 1' | grep ": values"
  : values=0
```

Now I can see the available routing options and that both headphone inputs are currently set to 'None' (value 0). Based on the UCM configuration I saw earlier, we should use 'DP5RX1' and 'DP5RX2' for headphones (items 13 and 14).

Updated ~/audio-headphones.sh:

```sh
#!/bin/bash
echo "Switching to headphones..."

# Disable CS35L56 speaker amplifiers
amixer -c2 cset name='AMP1 Speaker Switch' off 2>/dev/null
amixer -c2 cset name='AMP2 Speaker Switch' off 2>/dev/null
amixer -c2 cset name='AMP3 Speaker Switch' off 2>/dev/null
amixer -c2 cset name='AMP4 Speaker Switch' off 2>/dev/null
amixer -c2 cset name='Speaker Switch' off 2>/dev/null

# Enable headphone routing - use DP5RX1/DP5RX2 (items 13/14)
amixer -c2 cset name='cs42l43 Headphone L Input 1' 13 2>/dev/null  # DP5RX1
amixer -c2 cset name='cs42l43 Headphone R Input 1' 14 2>/dev/null  # DP5RX2
amixer -c2 cset name='cs42l43 Headphone Digital Volume' 200 2>/dev/null

echo "Headphones enabled"
```

Updated ~/audio-speakers.sh:

```sh
#!/bin/bash
echo "Switching to speakers..."

# Disable headphones
amixer -c2 cset name='cs42l43 Headphone L Input 1' 0 2>/dev/null  # None
amixer -c2 cset name='cs42l43 Headphone R Input 1' 0 2>/dev/null  # None

# Enable CS35L56 speaker amplifiers
amixer -c2 cset name='AMP1 Speaker Switch' on 2>/dev/null
amixer -c2 cset name='AMP2 Speaker Switch' on 2>/dev/null
amixer -c2 cset name='AMP3 Speaker Switch' on 2>/dev/null
amixer -c2 cset name='AMP4 Speaker Switch' on 2>/dev/null
amixer -c2 cset name='Speaker Switch' on 2>/dev/null

echo "Speakers enabled"
```

Now let's test:

1. Test headphone switching:

```sh
~/audio-headphones.sh
speaker-test -D plughw:2,2 -c 2 -t sine -f 440 -l 2
```

2. Test speaker switching:

```sh
~/audio-speakers.sh
speaker-test -D plughw:2,2 -c 2 -t sine -f 440 -l 2
```

3. Verify the routing changes:

```sh
# After running headphone script, check:
amixer -c2 cget name='cs42l43 Headphone L Input 1' | grep ": values"
amixer -c2 cget name='cs42l43 Headphone R Input 1' | grep ": values"

# After running speaker script, check:
amixer -c2 cget name='AMP1 Speaker Switch' | grep ": values"
```

Please test these updated scripts and let me know if you get audio from headphones vs speakers with each
script!

```sh
> LinuxNotes main ? ❯   speaker-test -D plughw:2,2 -c 2 -t sine -f 440 -l 2

  speaker-test 1.2.14

  Playback device is plughw:2,2
  Stream parameters are 48000Hz, S16_LE, 2 channels
  Sine wave rate is 440.0000Hz
  Rate set to 48000Hz (requested 48000Hz)
  Buffer size range from 192 to 1048576
  Period size range from 48 to 524288
  Periods = 4
  was set period_size = 12000
  was set buffer_size = 48000
   0 - Front Left
   1 - Front Right
  Time per period = 5.005964
   0 - Front Left
   1 - Front Right
  Time per period = 6.000085
```

This resulted in no sound playing at all after executing scripts/audio-headphones.sh

It's worth noting that my old configuration option for `sof-soundwire` in my audio settings is either:
- Off
- Pro Audio

That's a critical clue! The "Pro Audio" vs "Off" options indicate that the UCM provides are not loading properly. This explains why there's no proper headphone/speaker device separation - the system is falling back to a basic "Pro Audio" profile that just exposes raw PCM devices without proper device management.

This is exactly the fundamental UCM issue I identified earlier. Let's check what's happening:

```sh
# Check which audio system is running
systemctl --user status pipewire 2>/dev/null || systemctl --user status pulseaudio 2>/dev/null || echo
"Neither PipeWire nor PulseAudio found"

# Check what UCM profiles are being loaded
pactl list cards | grep -A 20 "sof-soundwire"
```

Also, let's see what UCM is actually detecting for your card:

```sh
# Check UCM card detection
alsaucm listcards | grep -i sof
```

The issue is that without proper UCM profiles loading, we only get the "Pro Audio" profile which gives direct
access to PCM devices but no automatic switching logic. We need to move to Phase 2 to fix the UCM
configuration.

Should we proceed to Phase 2 where we create a proper UCM override to fix the fundamental profile loading
issue? This will give you proper "Speakers" and "Headphones" options in your audio settings instead of just
"Pro Audio".

```sh
> LinuxNotes main ? ❯   systemctl --user status pipewire 2>/dev/null || systemctl --user status pulseaudio 
2>/dev/null || echo "Neither PipeWire nor PulseAudio found"
pipewire.service - PipeWire Multimedia Service
      Loaded: loaded (/usr/lib/systemd/user/pipewire.service; disabled; preset: enabled)
      Active: active (running) since Tue 2025-08-26 08:48:11 EDT; 47min ago
  Invocation: 51ed15fec6984a20b2f5c7aec20685b0
TriggeredBy: ● pipewire.socket
    Main PID: 2517 (pipewire)
      Tasks: 3 (limit: 37276)
      Memory: 17.9M (peak: 21.1M)
        CPU: 1.102s
      CGroup: /user.slice/user-1000.slice/user@1000.service/session.slice/pipewire.service
              └─2517 /usr/bin/pipewire

Aug 26 08:48:11 terminal systemd[1838]: Started PipeWire Multimedia Service.
bash: command not found: Neither PipeWire nor PulseAudio found
```

Great! PipeWire is running. Let's check what profiles PipeWire sees for your sound card:

```sh
# Check what PipeWire sees for the sof-soundwire card
wpctl status | grep -A 10 -B 5 "sof-soundwire"

# Check UCM card detection
alsaucm listcards 2>/dev/null || echo "UCM not available or no cards detected"
```

The issue is clear now - without proper UCM profiles, PipeWire can only offer the basic "Pro Audio" profile
instead of proper device-specific profiles (like "HiFi" with separate Headphones/Speakers devices).

Let's also verify the card components string that UCM uses for matching:

```sh
# This should show us what UCM is looking for
cat /sys/class/sound/card*/device/driver/*/components 2>/dev/null | grep -v "^$" || echo "No components found"

# Alternative path
find /sys -name "components" -path "*sound*" -exec cat {} \; 2>/dev/null | grep -v "^$" || echo "No components
  found via alternative path"
```

Based on what we find, we'll need to move to Phase 2 to create a proper UCM configuration. The fundamental
issue is that your system isn't loading the correct UCM profile that would provide proper headphone/speaker
device separation.

```sh
> LinuxNotes main ? ✗   wpctl status | grep -A 10 -B 5 "sof-soundwire"

LinuxNotes main ? ✗   alsaucm listcards 2>/dev/null || echo "UCM not available or no cards detected"
  0: hw:0
    Dell-WD15-Dock

LinuxNotes main ? ❯   cat /sys/class/sound/card*/device/driver/*/components 2>/dev/null | grep -v "^$" || echo "No components found"
No components found

LinuxNotes main ? ❯   find /sys -name "components" -path "*sound*" -exec cat {} \; 2>/dev/null | grep -v "^$" || echo "No components found via alternative path"
No components found via alternative path
```

This is the root cause! UCM only detects the dock (card 0) but not the sof-soundwire card (card 2). The
missing components file is critical - that's what UCM uses to match hardware to the correct profile.

Let's check a few more things to understand why UCM isn't detecting the sof-soundwire card:

```sh
# Check the card's name and driver information
cat /proc/asound/card2/id
cat /sys/class/sound/card2/device/driver/module/version 2>/dev/null || echo "No module version"

# Check if there's a components file in the right location
find /sys/class/sound/card2 -name "*component*" 2>/dev/null
ls -la /sys/class/sound/card2/device/

# Check what PipeWire actually sees - let's try a more targeted approach
wpctl status | grep -i audio
```

The fundamental issue is that without the components string, UCM can't identify your specific hardware
configuration to load the right profile. The SOF driver should be providing this information but it's not
appearing where UCM expects it.

This means we need to move to Phase 2 where we'll create a custom UCM configuration that works with your
specific setup, bypassing the missing components detection.

Should we proceed to Phase 2 where we create a custom UCM configuration to fix this fundamental detection
issue?

```sh
> LinuxNotes main ? ❯   cat /proc/asound/card2/id
sofsoundwire

LinuxNotes main ? ❯   cat /sys/class/sound/card2/device/driver/module/version 2>/dev/null || echo "No module 
version"
  
No module version

LinuxNotes main ? ❯   find /sys/class/sound/card2 -name "*component*" 2>/dev/null

LinuxNotes main ? ❯   ls -la /sys/class/sound/card2/device/
Permissions Size User Date Modified Name
lrwxrwxrwx     - root 26 Aug 09:38   driver -> ../../../../bus/platform/drivers/sof_sdw
drwxr-xr-x     - root 26 Aug 09:38   HDMI1
drwxr-xr-x     - root 26 Aug 09:38   HDMI2
drwxr-xr-x     - root 26 Aug 09:38   HDMI3
drwxr-xr-x     - root 26 Aug 09:38   iDisp1
drwxr-xr-x     - root 26 Aug 09:38   iDisp2
drwxr-xr-x     - root 26 Aug 09:38   iDisp3
drwxr-xr-x     - root 26 Aug 09:38   Microphone
drwxr-xr-x     - root 26 Aug 09:38   power
drwxr-xr-x     - root 26 Aug 09:38   SDW0-Capture-SmartMic
drwxr-xr-x     - root 26 Aug 09:38   SDW2-Capture-SmartAmp
drwxr-xr-x     - root 26 Aug 09:38   SDW2-Playback-SmartAmpa
drwxr-xr-x     - root 26 Aug 09:38   sound
drwxr-xr-x     - root 26 Aug 09:38   Speaker
lrwxrwxrwx     - root 26 Aug 09:38   subsystem -> ../../../../bus/platform
.rw-r--r--  4.1k root 26 Aug 09:38  󰡯 driver_override
.r--r--r--  4.1k root 26 Aug 09:38  󰡯 modalias
.rw-r--r--  4.1k root 26 Aug 09:38  󰡯 uevent

LinuxNotes main ? ❯   wpctl status | grep -i audio
Audio
  │      47. AD106M High Definition Audio Controller [alsa]
  │      48. USB Audio                           [alsa]
  │      49. Meteor Lake-P HD Audio Controller   [alsa]
  │  *   46. Meteor Lake-P HD Audio Controller Pro [vol: 0.33]
  │     105. Meteor Lake-P HD Audio Controller Pro 6 [vol: 1.00]
  │     106. Meteor Lake-P HD Audio Controller Pro 7 [vol: 1.00]
  │     107. Meteor Lake-P HD Audio Controller Pro 5 [vol: 1.00]
  │  *  104. Meteor Lake-P HD Audio Controller Pro 4 [vol: 0.50]
```

Perfect! Now I can see the complete picture. The issue is crystal clear:

1. UCM Detection Problem: The sof-soundwire card has no components file, so UCM can't auto-detect the proper
configuration
2. PipeWire Fallback: PipeWire is seeing the card as "Meteor Lake-P HD Audio Controller Pro" - the generic
fallback "Pro Audio" profile
3. Missing Device Separation: Without UCM, there's no separation between Speaker and Headphone devices

Notice in the device listing, you can see Speaker and Microphone directories, which means the hardware
topology is there, but UCM can't access it properly.

Phase 1 Conclusion

Your manual scripts work correctly at the ALSA level (routing is set, amps are controlled), but the audio
isn't reaching the headphones because the fundamental UCM profile system is broken.

Ready for Phase 2?

We need to create a custom UCM configuration that:
1. Properly identifies your sof-soundwire card
2. Creates proper "HiFi" profile with Speaker and Headphone devices
3. Uses the correct PCM routing and ALSA controls we've identified
4. Gives you proper "Speakers" and "Headphones" options in your audio settings

This will fix the root cause and give you native Linux audio behavior instead of manual script workarounds.

### Phase 2 - Create UCM Configuration


Step 5: Test the UCM Configuration

Now let's reload the audio system to apply the changes:

```sh
# Restart PipeWire to pick up the new UCM configuration
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check if UCM now detects the card
alsaucm listcards
```

Let me know if the sofsoundwire card now appears in the UCM list!
