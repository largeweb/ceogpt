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
xdotool mousemove 157 179 # click suggestions channel
sleep 1
xdotool click 1
sleep 1
xdotool click 1
sleep 1
xdotool mousemove 109 110 # dropdown CEOGPT channel
sleep 1
xdotool click 1
sleep 1
xdotool mousemove 157 179 # click suggestions channel
sleep 1
xdotool click 1
sleep 1
xdotool click 1
sleep 1
xdotool key ctrl+a
sleep 1
xdotool key ctrl+c
sleep 1
xsel -ob > ${cwd}/prompts/details.txt
sleep 1

# Limit variables
line_limit=300
total_limit=1000
max_lines=15

# Function to trim a line to the specified length
trim_line() {
  local line="$1"
  echo "${line:0:$line_limit}"
}

# Read the contents of details.txt
content=$(cat ${cwd}/prompts/details.txt)

# Trim each line to the line_limit length
trimmed_lines=""
while IFS= read -r line; do
  trimmed_line=$(trim_line "$line")
  trimmed_lines+="$trimmed_line"$'\n'
done <<< "$content"

# Process the lines in reverse order and add them until the total limit or line count is reached
output=""
current_length=0
line_count=0
while IFS= read -r line; do
  line_length=${#line}
  if ((current_length + line_length <= total_limit)) && ((line_count < max_lines)); then
    output="$line"$'\n'"$output"
    current_length=$((current_length + line_length))
    line_count=$((line_count + 1))
  else
    break
  fi
done <<< "$(echo "$trimmed_lines" | tac)"

# Add "Community Suggestions" at the top
output="Community Suggestions"$'\n'"$output"

sleep 1
xdotool mousemove 109 110
sleep 2
xdotool key ctrl+shift+w
sleep 1
xdotool key Return
sleep 1

echo "CEOGPT ran the readdiscordsuggestions script. Please wait for CEOGPT to respond." > ${cwd}/prompts/response.txt