#!/bin/bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

# echo "called with $1" >>/tmp/aerospacesh_log
# echo "name is with $NAME" >>/tmp/aerospacesh_log
# echo "focused workspace is $FOCUSED_WORKSPACE" >>/tmp/aerospacesh_log

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on
else
  sketchybar --set $NAME background.drawing=off
fi
