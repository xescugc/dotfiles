#! /bin/bash
xbanish &
clipit &
xset r rate 150 70
xset m 3/2 0
xset -b
dunst &
setxkbmap us
exec i3

