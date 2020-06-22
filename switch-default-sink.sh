#!/bin/bash

# Step 1: switch default sink
CURRENT_SINK_INDEX=$(pacmd list-sinks | grep "* index" | sed -E 's/.*: ([0-9]*)$/\1/')

# Create array of connected sinks
CONNECTED_DEVICES=($(pacmd list-sinks | grep "index" | sed -E 's/.*: ([0-9]*)$/\1/'))
CONNECTED_DEVICES_LENGTH=$(echo "${#CONNECTED_DEVICES[@]}")

# Go to next sink index (aka switch sink)
NEW_INDEX=$((CURRENT_SINK_INDEX + 1))
NEW_INDEX=$((NEW_INDEX % $CONNECTED_DEVICES_LENGTH))
pacmd set-default-sink $NEW_INDEX

# Step 2: Move all current streams (active inputs which are playing) to the new sink
pacmd list-sink-inputs | grep index | while read input; do
    SINK_INPUT_INDEX=$(echo $input | sed -E 's/.*: ([0-9]*)$/\1/')
    pacmd move-sink-input $SINK_INPUT_INDEX $NEW_INDEX
done