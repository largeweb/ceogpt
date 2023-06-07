#!/bin/bash

cwd=$(pwd)
echo "cwd is $cwd"

# This will take the user's input, encode it for URL compatibility, navigate to DuckDuckGo, collect the links, and paste them in a usable format.

INPUT=""
for i in "${@}"; do
    ENCODED=$(printf '%s' "$i" | jq -sRr @uri)
    INPUT="${INPUT}${ENCODED}+"
done

# Remove the trailing '+' character
INPUT=${INPUT%?}

URL="https://duckduckgo.com/html/?q=$INPUT"

curl -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101 Firefox/87.0' -L -s "$URL" | sed -n 's/.*class="result__url".*href="\([^"]*\)".*/\1/p'

echo "findlinks.sh ran but no response configured. Notify the user." > ${cwd}/prompts/response.txt
