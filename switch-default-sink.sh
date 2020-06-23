#!/bin/bash

# Step 1: switch default sink

# Find current default sink and create array of connected sinks
CURRENT_DEFAULT_SINK=$(pacmd stat | grep "Default sink name" | sed -E 's/.*: (.*)$/\1/')
CONNECTED_SINKS=($(pacmd list-sinks | grep "name: " | sed -E 's/.*<(.*)>$/\1/'))
CONNECTED_DEVICES_AMOUNT=$(echo "${#CONNECTED_SINKS[@]}")

# Find current default sink in sink array and select next sink in the list
for i in "${!CONNECTED_SINKS[@]}"; do
    if [[ "${CONNECTED_SINKS[$i]}" == $CURRENT_DEFAULT_SINK ]]; then
        NEW_DEFAULT_SINK_INDEX=$((i + 1))
        NEW_DEFAULT_SINK_INDEX=$((NEW_DEFAULT_SINK_INDEX % $CONNECTED_DEVICES_AMOUNT))
        break
    fi
done
NEW_DEFAULT_SINK="${CONNECTED_SINKS[$NEW_DEFAULT_SINK_INDEX]}"
# Update to new default-sink
pacmd set-default-sink $NEW_DEFAULT_SINK

# Step 2: Move all current streams (active inputs which are playing) to the new sink
pacmd list-sink-inputs | grep index | while read input; do
    SINK_INPUT_INDEX=$(echo $input | sed -E 's/.*: ([0-9]*)$/\1/')
    pacmd move-sink-input $SINK_INPUT_INDEX $NEW_DEFAULT_SINK
done