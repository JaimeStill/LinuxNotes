#!/bin/bash

CARD=$(cat /proc/asound/cards | grep -E "sof.*soundwire" | cut -d' ' -f2)

echo "Testing different headphone routing options on card $CARD..."
echo "Plug in your headphones and press Enter after each test"
echo "Type 'y' if you hear sound, 'n' if not"
echo

# Disable speakers first
amixer -c$CARD cset name='AMP1 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP2 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP3 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='AMP4 Speaker Switch' off 2>/dev/null
amixer -c$CARD cset name='Speaker Switch' off 2>/dev/null

# Test 1: ASPRX1/ASPRX2 with higher volumes
echo "Test 1: ASPRX1/ASPRX2 routing"
amixer -c$CARD cset name='cs42l43 Headphone L Input 1' 7
amixer -c$CARD cset name='cs42l43 Headphone R Input 1' 8
amixer -c$CARD cset name='cs42l43 Headphone L Input 1 Volume' 100
amixer -c$CARD cset name='cs42l43 Headphone R Input 1 Volume' 100
amixer -c$CARD cset name='cs42l43 Headphone Digital Volume' 255
speaker-test -D plughw:$CARD,2 -c 2 -t sine -f 440 -l 1
read -p "Did you hear sound? (y/n): " response
[ "$response" = "y" ] && echo "WORKING: ASPRX1/ASPRX2" && exit 0

# Test 2: Try multiple inputs simultaneously
echo -e "\nTest 2: Multiple inputs on L/R channels"
amixer -c$CARD cset name='cs42l43 Headphone L Input 1' 13
amixer -c$CARD cset name='cs42l43 Headphone L Input 2' 7
amixer -c$CARD cset name='cs42l43 Headphone R Input 1' 14
amixer -c$CARD cset name='cs42l43 Headphone R Input 2' 8
amixer -c$CARD cset name='cs42l43 Headphone L Input 2 Volume' 100
amixer -c$CARD cset name='cs42l43 Headphone R Input 2 Volume' 100
speaker-test -D plughw:$CARD,2 -c 2 -t sine -f 440 -l 1
read -p "Did you hear sound? (y/n): " response
[ "$response" = "y" ] && echo "WORKING: Multiple inputs" && exit 0

# Test 3: Try ASRC paths
echo -e "\nTest 3: ASRC INT1/INT2 routing"
amixer -c$CARD cset name='cs42l43 Headphone L Input 1' 19
amixer -c$CARD cset name='cs42l43 Headphone R Input 1' 20
speaker-test -D plughw:$CARD,2 -c 2 -t sine -f 440 -l 1
read -p "Did you hear sound? (y/n): " response
[ "$response" = "y" ] && echo "WORKING: ASRC INT1/INT2" && exit 0

echo -e "\nNo working configuration found. Headphones may need additional configuration."
