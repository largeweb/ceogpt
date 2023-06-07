#!/bin/bash

cwd=$(pwd)
echo "cwd is $cwd"

DETAILCONTENTS=$(cat ${cwd}/prompts/details.txt)
echo "Details from Last CEOGPT Action: " > ${cwd}/prompts/details.txt
echo "$DETAILCONTENTS" >> ${cwd}/prompts/details.txt

files=(
  ${cwd}/prompts/initialprompt.txt
  ${cwd}/prompts/datetime.txt
  ${cwd}/prompts/largegoal.txt
  ${cwd}/prompts/companystatus.txt
  ${cwd}/prompts/recentcontext.txt
  ${cwd}/prompts/details.txt
  ${cwd}/prompts/availableactions.txt
  ${cwd}/prompts/narrowgoal.txt
  ${cwd}/prompts/thinking.txt
  ${cwd}/prompts/endingprompt.txt
)

: > ${cwd}/prompts/prompt.txt

for file in "${files[@]}"; do
  cat "$file" >> ${cwd}/prompts/prompt.txt
  echo >> ${cwd}/prompts/prompt.txt
done

cat ${cwd}/prompts/prompt.txt | xsel -ib

echo "running xdotool wait 1 min part"
sleep 180
xdotool mousemove 1234 1247 click 1
sleep 1
cat ${cwd}/prompts/prompt.txt | xsel -ib
sleep 1
xdotool key ctrl+v
sleep 1
xdotool key Return
