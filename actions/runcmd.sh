#!/bin/bash

cwd=$(pwd)
echo "cwd is $cwd"

INPUTTEXT=$(cat ${cwd}/prompts/nextaction.txt)
INPUTTEXT=${INPUTTEXT:13}
CMDTORUN=$(python3 ${cwd}/inference/inferonce.py "$INPUTTEXT")
echo "cmdtorun is $CMDTORUN"
CMDINPUT=$(cat ${cwd}/prompts/actioninput.txt)
echo "cmdinput is $CMDINPUT"
OUTPUT=$(bash "$CMDTORUN" "$CMDINPUT")