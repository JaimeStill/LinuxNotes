#!/bin/bash

# Find the sof-soundwire card number dynamically
CARD=$(cat /proc/asound/cards | grep -E "sof.*soundwire" | cut -d' ' -f2)

if [ -z "$CARD" ]; then
  echo "Error: sof-soundwire card not found"
  exit 1
fi

echo "Switching to speakers on card $CARD..."

# Reset Jack Override to None
amixer -c$CARD cset name='cs42l43 Jack Override' 0 2>/dev/null # 0 = None

# Disable headphones
amixer -c$CARD cset name='cs42l43 Headphone L Input 1' 0 2>/dev/null
amixer -c$CARD cset name='cs42l43 Headphone R Input 1' 0 2>/dev/null

# Enable CS35L56 speaker amplifiers
amixer -c$CARD cset name='AMP1 Speaker Switch' on 2>/dev/null
amixer -c$CARD cset name='AMP2 Speaker Switch' on 2>/dev/null
amixer -c$CARD cset name='AMP3 Speaker Switch' on 2>/dev/null
amixer -c$CARD cset name='AMP4 Speaker Switch' on 2>/dev/null
amixer -c$CARD cset name='Speaker Switch' on 2>/dev/null

echo "Speakers enabled on card $CARD"

# Save state
echo "speakers" >~/.config/audio-output-state
