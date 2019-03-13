#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run nm-applet
xinput set-prop "SYNA7DAB:00 06CB:7DAB Touchpad" "libinput Tapping Enabled" 1
#run cbatticon
#run pasystray
run compton -b
run xscreensaver -no-splash &
run setxkbmap -layout "us,de"
