#!/bin/bash

notify-send "researchx.sh started."

echo "system note: researchx.sh started."

cwd=$(pwd)
echo "cwd is $cwd"

INPUT=""
for i in "${@}"; do
    ENCODED=$(printf '%s' "$i" | jq -sRr @uri)
    INPUT="${INPUT}${ENCODED}+"
done

# Remove the trailing '+' character
INPUT=${INPUT%?}

URL="https://duckduckgo.com/html/?q=$INPUT"

links=$(curl -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101 Firefox/87.0' -L -s "$URL" | sed -n 's/.*class="result__url".*href="\([^"]*\)".*/\1/p' | head -n 3)

RESEARCHOUTPUT=$(python3 ${cwd}/actions/researchx.py $links)
echo $RESEARCHOUTPUT > $cwd/prompts/details.txt
echo "system note: researchx.sh appended to details."
echo "CEOGPT ran the research script and captured the details. Please wait for CEOGPT to respond." > $cwd/prompts/response.txt