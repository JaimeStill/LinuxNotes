#!/bin/bash

CARD=$(cat /proc/asound/cards | grep -E "sof.*soundwire" | cut -d' ' -f2)

echo "Comprehensive CS42L43 headphone test on card $CARD"
echo "Testing all Jack Override modes with different routings"
echo

# Disable speakers first
amixer -c$CARD cset name='AMP1 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP2 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP3 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP4 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='Speaker Switch' off 2>/dev/null

# Set volumes high
amixer -c$CARD cset name='cs42l43 Headphone L Input 1 Volume' 127 2>/dev/null
amixer -c$CARD cset name='cs42l43 Headphone R Input 1 Volume' 127 2>/dev/null
amixer -c$CARD cset name='cs42l43 Headphone Digital Volume' 255 2>/dev/null

# Enable Speaker Digital Switch (might be needed for any output)
amixer -c$CARD cset name='cs42l43 Speaker Digital Switch' on 2>/dev/null

JACK_MODES=("None" "CTIA" "OMTP" "Headphone" "Line-Out" "Line-In" "Microphone" "Optical")
ROUTING_MODES=("DP5RX1/2:13,14" "ASPRX1/2:7,8" "ASPRX3/4:9,10" "ASPRX5/6:11,12")

for jack_idx in 0 1 2 3 4; do
  jack_name=${JACK_MODES[$jack_idx]}
  echo "Testing Jack Override: $jack_name ($jack_idx)"
  amixer -c$CARD cset name='cs42l43 Jack Override' $jack_idx 2>/dev/null

  for routing in "${ROUTING_MODES[@]}"; do
    route_name=${routing%%:*}
    left_val=$(echo ${routing#*:} | cut -d',' -f1)
    right_val=$(echo ${routing#*:} | cut -d',' -f2)

    echo "  - Routing: $route_name"
    amixer -c$CARD cset name='cs42l43 Headphone L Input 1' $left_val 2>/dev/null
    amixer -c$CARD cset name='cs42l43 Headphone R Input 1' $right_val 2>/dev/null

    timeout 2s speaker-test -D plughw:$CARD,2 -c 2 -t sine -f 440 >/dev/null 2>&1 &
    read -p "    Sound? (y/n/s to skip jack mode): " response
    killall speaker-test 2>/dev/null

    if [ "$response" = "y" ]; then
      echo "SUCCESS! Working config:"
      echo "  Jack Override: $jack_name ($jack_idx)"
      echo "  Routing: $route_name (L=$left_val, R=$right_val)"
      exit 0
    elif [ "$response" = "s" ]; then
      break
    fi
  done
  echo
done

echo "No working configuration found."
