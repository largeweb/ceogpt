#!/bin/bash

cwd=$(pwd)
echo "cwd is $cwd"

read -r INPUTTEXT < ${cwd}/prompts/actioninput.txt

echo "$INPUTTEXT" | xsel -b

vivaldi &
sleep 5
xdotool key F11
sleep 3
xdotool key ctrl+l
sleep 1
xdotool type --delay 50 "https://discord.com/channels/@me"
sleep 1
xdotool key Return
sleep 5
xdotool mousemove 995 808 # click on login
sleep 1
xdotool click 1
sleep 1
xdotool mousemove 1139 750 # click on login
sleep 1
xdotool click 1
sleep 3
xdotool mousemove 1055 876 # click submit
sleep 1
xdotool click 1
sleep 5
xdotool mousemove 37 98 # click CB channel
sleep 1
xdotool click 1
sleep 1
xdotool mousemove 109 110 # dropdown CEOGPT channel
sleep 1
xdotool click 1
sleep 1
xdotool mousemove 160 142 # click announcements channel
sleep 1
xdotool click 1
sleep 1
xdotool mousemove 516 1398 # click message box
sleep 1
xdotool key ctrl+v
sleep 1
xdotool key Return
sleep 2
xdotool mousemove 109 110
sleep 2
xdotool key ctrl+shift+w
sleep 1
xdotool key Return
sleep 1
echo "The last action was to post a Discord announcement and this has been completed." > ${cwd}/prompts/details.txt

echo "CEOGPT ran the postdiscordannouncement script. Please wait for CEOGPT to respond." > ${cwd}/prompts/response.txt