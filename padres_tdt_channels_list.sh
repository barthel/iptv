#!/bin/bash

# Local storage paths for the JSON files
LOCAL_JSON_INPUT_FILE="tv.json"
LOCAL_JSON_OUTPUT_FILE="padres_tv.json"
CHANNEL_MAP_FILE="padres_map.json"

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to use this script."
    exit 1
fi

# Ausgabe der Kanäle ohne 'options' mit dem 'm3u8'-Format
_jq_output=$(jq '[
    .countries[].ambits[].channels[] |
    select(.options | all(.format != "m3u8")) |
    .name
]' "${LOCAL_JSON_INPUT_FILE}")

# echo "Kanäle ohne 'm3u8'-Format:"
# echo "${_jq_output}"

# JSON bearbeiten, um fehlende 'options'-Einträge mit spezifischer URL basierend auf Kanalnamen hinzuzufügen
jq --slurpfile map "${CHANNEL_MAP_FILE}" '
    .countries[].ambits[].channels |= map(
        if (.options | all(.format != "m3u8")) and (($map[0][(.name | gsub(" "; ""))] // null) != null) then
            .options += [{
                "format": "m3u8",
                "url": ($map[0][(.name | gsub(" "; ""))] // null),
                "geo2": null,
                "res": null,
                "lang": null
            }]
        else
            .
        end
    )
' "${LOCAL_JSON_INPUT_FILE}" > "${LOCAL_JSON_OUTPUT_FILE}"

# Ausgabe Ergebnis
echo "JSON file was extended."