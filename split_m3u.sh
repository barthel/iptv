#!/bin/bash
#
# split_m3u.sh
#
# Dieses Script teilt eine M3U-Datei in N gleichgroße Teile auf, wobei der Header
# (z. B. "#EXTM3U") aus der ersten Zeile in jede Ausgabe-Datei übernommen wird.
#
# Verwendung:
#   ./split_m3u.sh input_file number_of_parts output_directory
#
# Beispiel:
#   ./split_m3u.sh playlist.m3u 10 ../split/
#

# Überprüfen der Parameteranzahl
if [ "$#" -ne 3 ]; then
  echo "Usage: ${0} input_file number_of_parts output_directory"
  exit 1
fi

input_file="${1}"
num_parts="${2}"
output_dir="${3}"

# Prüfen, ob die Eingabedatei existiert
if [ ! -f "${input_file}" ]; then
  echo "Error: Input file '${input_file}' does not exist."
  exit 1
fi

# Erstelle das Ausgabeverzeichnis, falls es nicht existiert
mkdir -p "${output_dir}"

# Lese den Header (erste Zeile) aus der M3U-Datei
header=$(head -n 1 "${input_file}")

# Gesamte Anzahl der Zeilen der Datei ermitteln
total_lines=$(wc -l < "$input_file")

# Wenn die Datei nur den Header enthält, ist nichts zu splitten
if [ "${total_lines}" -le 1 ]; then
  echo "No entries to split in '${input_file}'."
  exit 0
fi

# Anzahl der Zeilen (ohne Header)
content_lines=$(( total_lines - 1 ))

# Berechne die Basisanzahl der Zeilen pro Teil-Datei und den Rest,
# der gleichmäßig auf die ersten Teile verteilt wird.
base_lines=$(( content_lines / num_parts ))
remainder=$(( content_lines % num_parts ))

# Startzeile für den Inhalt (die erste Zeile ist der Header)
start_line=2

for (( i=0; i<num_parts; i++ ))
do
  # Berechnet die Zeilenanzahl für diesen Teil – verteile einen Überschuss
  part_lines=${base_lines}
  if [ ${i} -lt ${remainder} ]; then
    part_lines=$(( part_lines + 1 ))
  fi

  # Setze den Ausgabedateinamen: originalname.part.<Index>
  output_file="${output_dir}/_${i}_part_$(basename "${input_file}")"
  
  # Schreibe den Header in die Ausgabedatei
  echo "${header}" > "${output_file}"

  # Falls es Inhalt gibt, extrahiere die entsprechenden Zeilen mittels sed
  if [ "${part_lines}" -gt 0 ]; then
    sed -n "${start_line},$(( start_line + part_lines - 1 ))p" "${input_file}" >> "${output_file}"
  fi

  echo "Created ${output_file} with ${part_lines} lines (excluding header)."
  
  # Aktualisiere den Startzeilenindex für den nächsten Teil
  start_line=$(( start_line + part_lines ))
done
