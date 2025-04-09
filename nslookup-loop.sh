#!/bin/bash

# @badt4ste

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 targets.txt output.txt"
    exit 1
fi

TARGET_FILE="$1"
OUTPUT_FILE="$2"

# Start fresh output file
echo "NSLOOKUP Results — $(date)" > "$OUTPUT_FILE"
echo "===============================" >> "$OUTPUT_FILE"

# Loop through each URL
while IFS= read -r url || [ -n "$url" ]; do
    url=$(echo "$url" | xargs)  # Trim whitespace

    # Skip empty lines or commented lines
    if [[ -z "$url" || "$url" == \#* ]]; then
        continue
    fi

    echo "🔍 Performing nslookup for: $url"
    echo "🔍 Performing nslookup for: $url" >> "$OUTPUT_FILE"

    # Run nslookup and append to output file
    nslookup "$url" >> "$OUTPUT_FILE" 2>&1

    echo "-------------------------------------" >> "$OUTPUT_FILE"
done < "$TARGET_FILE"

echo "Done! Results saved to: $OUTPUT_FILE"
