#!/bin/bash

# Find the sof-soundwire card number dynamically
CARD=$(cat /proc/asound/cards | grep -E "sof.*soundwire" | cut -d' ' -f2)

if [ -z "$CARD" ]; then
  echo "Error: sof-soundwire card not found"
  exit 1
fi

echo "Switching to headphones on card $CARD..."

# CRITICAL: Set Jack Override to Headphone mode
amixer -c$CARD cset name='cs42l43 Jack Override' 3 2>/dev/null # 3 = Headphone

# Disable CS35L56 speaker amplifiers
amixer -c$CARD cset name='AMP1 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP2 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP3 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP4 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='Speaker Switch' off 2>/dev/null

# Enable headphone routing - DP5RX1/DP5RX2
amixer -c$CARD cset name='cs42l43 Headphone L Input 1' 13 2>/dev/null
amixer -c$CARD cset name='cs42l43 Headphone R Input 1' 14 2>/dev/null
amixer -c$CARD cset name='cs42l43 Headphone L Input 1 Volume' 100 2>/dev/null
amixer -c$CARD cset name='cs42l43 Headphone R Input 1 Volume' 100 2>/dev/null
amixer -c$CARD cset name='cs42l43 Headphone Digital Volume' 200 2>/dev/null

echo "Headphones enabled on card $CARD"

# Save state
echo "headphones" >~/.config/audio-output-state
