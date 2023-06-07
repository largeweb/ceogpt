#!/bin/bash

cwd=$(pwd)
echo "cwd is $cwd"

echo "Texting CEO"
notify-send "Texting CEO"

body=$1
for i in "${@:2}"; do
    body="$body $i"
done
phone_number="+17043515396"

echo "Body: $body"

curl -X POST "https://api.twilio.com/2010-04-01/Accounts/AC7b3743f5ad6958a20a7c04b53df90bd1/Messages.json" \
    --data-urlencode "Body=$body" \
    --data-urlencode "From=+18335640686" \
    --data-urlencode "To=$phone_number" \
    -u "AC7b3743f5ad6958a20a7c04b53df90bd1:af0e504b5f4edcf1ac8c48db297f0679"

echo $body >> log.txt
echo >> log.txt

echo "The last action was to Text the CEO and this has been completed." > ${cwd}/prompts/details.txt

echo "Script Ending"

echo "CEOGPT ran the textceo script. Please wait for CEOGPT to respond." > ${cwd}/prompts/response.txt
