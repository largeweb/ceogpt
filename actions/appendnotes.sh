#!/bin/bash

echo "system note: appendnotes.sh started."

cwd=$(pwd)
echo "cwd is $cwd"

read -r INPUTTEXT < $cwd/prompts/actioninput.txt
# get the first word
FILENAME=${INPUTTEXT%% *}

# remove the first word
INPUTTEXT=${INPUTTEXT#* }
# remove all leading and trailing whitespace
INPUTTEXT=$(echo "$INPUTTEXT" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# if the file exists, append the input text to it
if [ -f "$cwd/notes/$FILENAME" ]; then
    echo "$INPUTTEXT" >> $cwd/notes/$FILENAME
else
    # otherwise, create a new file with the input text
    echo "$INPUTTEXT" > $cwd/notes/$FILENAME
fi

echo "Note appended." > $cwd/prompts/details.txt
echo "system note: Note appended."
echo "CEOGPT added note to filesystem. Wait for CEOGPT to figure out what to do next." > $cwd/prompts/response.txt
echo "system note: Note added to filesystem."