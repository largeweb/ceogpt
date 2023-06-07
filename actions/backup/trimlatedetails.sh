#!/bin/bash

cwd=$(pwd)
echo "cwd is $cwd"

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

# Write the final output to details.txt
echo "$output" > ${cwd}/prompts/details.txt

echo "trimlatedetails.sh ran but no response configured. Notify the user." > ${cwd}/prompts/response.txt