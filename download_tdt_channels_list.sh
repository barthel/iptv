#!/bin/bash

# URL of the JSON file to download
JSON_URL="https://www.tdtchannels.com/lists/tv.json"
# Local storage path for the JSON file
LOCAL_JSON_FILE="tv.json"
# Path for storing the hash of the last downloaded JSON file
HASH_FILE="tv.hash"

# Download function for JSON
download_json() {
    echo "Downloading JSON file from $JSON_URL..."
    curl -s -o "$LOCAL_JSON_FILE" "$JSON_URL"
}

# Function to calculate hash and check if the file has changed
file_has_changed() {
    local current_hash
    current_hash=$(sha256sum "$LOCAL_JSON_FILE" | awk '{ print $1 }')

    if [ ! -f "$HASH_FILE" ] || [ "$(cat "$HASH_FILE")" != "$current_hash" ]; then
        echo "$current_hash" > "$HASH_FILE"
        return 0  # True that file has changed
    fi

    return 1  # False that file has not changed
}

# Download the JSON file
download_json

# Check if the JSON file has changed
if file_has_changed; then
  echo "The JSON file has changed. Creating new M3U playlist..."
  exit 1
fi
echo "The JSON file has not changed. No update needed."
exit 0
