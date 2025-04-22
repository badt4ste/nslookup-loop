#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 targets.txt output.txt"
    exit 1
fi

TARGET_FILE="$1"
OUTPUT_FILE="$2"
UNIQUE_IPS_FILE="${OUTPUT_FILE}_unique_ips.txt"

# Start fresh output files
echo "NSLOOKUP Results — $(date)" > "$OUTPUT_FILE"
echo "===============================" >> "$OUTPUT_FILE"
> "$UNIQUE_IPS_FILE"  # Clear or create unique IPs file

# Loop through each URL
while IFS= read -r url || [ -n "$url" ]; do
    url=$(echo "$url" | xargs)  # Trim whitespace

    # Skip empty lines or commented lines
    if [[ -z "$url" || "$url" == \#* ]]; then
        continue
    fi

    echo "Performing nslookup for: $url"
    echo "Performing nslookup for: $url" >> "$OUTPUT_FILE"

    # Run nslookup and append full output
    nslookup_output=$(nslookup "$url" 2>&1)
    echo "$nslookup_output" >> "$OUTPUT_FILE"
    echo "-------------------------------------" >> "$OUTPUT_FILE"

    # Extract IP addresses from nslookup output
    echo "$nslookup_output" | awk '/^Address: /{print $2}' >> "$UNIQUE_IPS_FILE"

done < "$TARGET_FILE"

# Now deduplicate the IPs file
sort "$UNIQUE_IPS_FILE" | uniq > "${UNIQUE_IPS_FILE}.tmp"
mv "${UNIQUE_IPS_FILE}.tmp" "$UNIQUE_IPS_FILE"

echo "Done!"
echo "Full NSLOOKUP results saved to: $OUTPUT_FILE"
echo "Unique IPs saved to: $UNIQUE_IPS_FILE"

