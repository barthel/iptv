#!/bin/bash

# URL of the M3U JSON file to download
M3U_JSON_URL="https://www.tdtchannels.com/lists/tv.json"
# Local storage path for the M3U JSON file
LOCAL_M3U_JSON_FILE="tv.json"
# Path for storing the hash of the last downloaded M3U JSON file
M3U_HASH_FILE="tv.hash"

# Download function for M3U JSON
download_m3u_json() {
    echo "Downloading M3U JSON file from ${M3U_JSON_URL}..."
    curl --compressed -s -o "${LOCAL_M3U_JSON_FILE}" "${M3U_JSON_URL}"
}

# Function to calculate hash and check if the file has changed
m3u_file_has_changed() {
    local current_hash
    current_hash=$(sha256sum "${LOCAL_M3U_JSON_FILE}" | awk '{ print $1 }')

    if [ ! -f "${M3U_HASH_FILE}" ] || [ "$(cat "${M3U_HASH_FILE}")" != "${current_hash}" ]; then
        echo "${current_hash}" > "${M3U_HASH_FILE}"
        return 0  # True that file has changed
    fi

    return 1  # False that file has not changed
}

# Download the M3U JSON file
download_m3u_json

# Check if the M3U JSON file has changed
if m3u_file_has_changed; then
  echo "The M3U JSON file has changed. Creating new M3U playlist..."
  exit 1
fi
echo "The M3U JSON file has not changed. No update needed."
exit 0
