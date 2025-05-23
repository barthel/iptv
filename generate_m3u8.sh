#!/bin/bash
# Local storage path for the JSON file
LOCAL_JSON_FILE="_tv.json"
M3U_FILE="tv.m3u8"

echo "Creating new M3U playlist..."

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to use this script."
    exit 1
fi

# Start the M3U file with the header and EPG URL
echo "#EXTM3U IPTV https://barthel.github.io/iptv/${M3U_FILE}" > "${M3U_FILE}"
echo "#EXTM3U url-tvg=\"https://barthel.github.io/iptv-epg/tv-epg.m3u8\"" >> "${M3U_FILE}"

# Parse JSON with jq to generate M3U entries
jq -r '
    .countries[] | .ambits[] as $ambit | 
    ( $ambit.channels[] as $channel |
        (
        if $channel.options then
            [ $channel.options[]? | select(.format == "m3u8") | .url ] |
            if length == 0 then
            [""]
            else
            to_entries | map(
                if .key > 0 then
                    "#EXTINF:-1 tvg-id=\"\($channel.epg_id)\" tvg-name=\"\($channel.name) [\(.key)]\" tvg-logo=\"\($channel.logo)\" group-title=\"\($ambit.name)\", \($channel.name)\n\(.value)"
                else
                    "#EXTINF:-1 tvg-id=\"\($channel.epg_id)\" tvg-name=\"\($channel.name)\" tvg-logo=\"\($channel.logo)\" group-title=\"\($ambit.name)\", \($channel.name)\n\(.value)"
                end
            )
            end
        else
            [""]
        end
        )
    ) | .[]
' "${LOCAL_JSON_FILE}" >> "${M3U_FILE}"
sed -i "" '/^$/d' "${M3U_FILE}"
echo "M3U playlist has been created: ${M3U_FILE}"
