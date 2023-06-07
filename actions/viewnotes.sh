#!/bin/bash

cwd=$(pwd)
echo "cwd is $cwd"

ACTIONINPUT=$(cat ${cwd}/prompts/actioninput.txt)
ACTIONINPUT=${ACTIONINPUT%%*( )}
ACTIONINPUT=${ACTIONINPUT%%*( )}
ACTIONINPUT=${ACTIONINPUT%% *}

if [ -n "$ACTIONINPUT" ]; then
    if [ -f "${cwd}/notes/$ACTIONINPUT" ]; then
        cat "${cwd}/notes/$ACTIONINPUT" > ${cwd}/prompts/details.txt
    else
        AVAILABLENOTES=$(ls ${cwd}/notes)
        echo "The note '$ACTIONINPUT' does not exist. Please provide a valid note name. Available notes: '$AVAILABLENOTES'." > ${cwd}/prompts/details.txt
    fi
else
    NOTES=$(ls ${cwd}/notes)
    if [ -n "$NOTES" ]; then
        echo "Here are your notes:" > ${cwd}/prompts/details.txt
        printf '%s\n' "$NOTES" >> ${cwd}/prompts/details.txt
        echo "Which note would you like to view?" >> ${cwd}/prompts/details.txt
    else
        echo "There are no notes to view. Feel free to create one." > ${cwd}/prompts/details.txt
    fi
fi

echo "CEOGPT ran the view notes script. Please wait for CEOGPT to respond." > ${cwd}/prompts/response.txt