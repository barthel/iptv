#!/bin/bash

# URL of the M3U JSON file to download
M3U_JSON_URL="https://www.tdtchannels.com/lists/tv.json"
# Local storage path for the M3U JSON file
LOCAL_M3U_JSON_FILE="tv.json"
# Path for storing the hash of the last downloaded M3U JSON file
M3U_HASH_FILE="tv.hash"

# URL of the M3U JSON file to download
EPG_XML_URL="https://www.tdtchannels.com/epg/TV.xml.gz"
LOCAL_EPG_XML_FILE="tv-epg.xml"
EPG_HASH_FILE="tv-epg.hash"

# Download function for M3U JSON
download_m3u_json() {
    echo "Downloading M3U JSON file from ${M3U_JSON_URL}..."
    curl --compressed -s -o "${LOCAL_M3U_JSON_FILE}" "${M3U_JSON_URL}"
}

# Download function for EPG XML
download_epg_xml() {
    echo "Downloading EPG XML file from ${EPG_XML_URL}..."
    curl --compressed -s -o "${LOCAL_EPG_XML_FILE}" "${EPG_XML_URL}"
    if [[ $(file -b --mime-type "${LOCAL_EPG_XML_FILE}" ) == "application/gzip" ]]; then
      mv "${LOCAL_EPG_XML_FILE}" "${LOCAL_EPG_XML_FILE}.gz"
      gzip -d "${LOCAL_EPG_XML_FILE}"
    fi
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

# Function to calculate hash and check if the file has changed
epg_file_has_changed() {
    local current_hash
    current_hash=$(sha256sum "${LOCAL_EPG_XML_FILE}" | awk '{ print $1 }')

    if [ ! -f "${EPG_HASH_FILE}" ] || [ "$(cat "${EPG_HASH_FILE}")" != "${current_hash}" ]; then
        echo "${current_hash}" > "${EPG_HASH_FILE}"
        return 0  # True that file has changed
    fi

    return 1  # False that file has not changed
}

# Download the M3U JSON file
download_m3u_json
# Download the EPG XML file
download_epg_xml

# Check if the M3U JSON file has changed
if m3u_file_has_changed; then
  echo "The M3U JSON file has changed. Creating new M3U playlist..."
  exit 1
fi
echo "The M3U JSON file has not changed. No update needed."
# Check if the EPG XML file has changed
if epg_file_has_changed; then
  echo "The EPG XML file has changed. Creating new EPG list..."
  exit 1
fi
echo "The EPG XML file has not changed. No update needed."
exit 0
