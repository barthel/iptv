#!/usr/bin/env python3

import os

# Stelle sicher, dass die Umgebungsvariable WHITELIST_DIR gesetzt ist
whitelist_dir = os.environ.get('WHITELIST_DIR')
if not whitelist_dir or not os.path.isdir(whitelist_dir):
    print("Das Verzeichnis für die Whitelist-Dateien ist nicht gesetzt oder existiert nicht.")
    exit(1)

# M3U-Datei festlegen
m3u_file = 'tv.m3u8'
if not os.path.isfile(m3u_file):
    print(f"Die angegebene M3U-Datei existiert nicht: {m3u_file}")
    exit(1)

# Lade alle Kanalnamen aus der Whitelist in eine Liste
whitelist_channels = []
whitelist_files = [f for f in os.listdir(whitelist_dir) if f.endswith('.whitelist')]
for file in whitelist_files:
    with open(os.path.join(whitelist_dir, file), 'r') as f:
        for line in f:
            channel = line.strip().strip('"')
            if channel:  # Nur nicht leere Kanäle hinzufügen
                whitelist_channels.append(channel)

    # Filtere die M3U-Datei basierend auf der Whitelist und den Namen der Whitelist-Datei verwenden
    output_file = f"{os.path.splitext(file)[0]}_{os.path.basename(m3u_file)}"
    with open(m3u_file, 'r') as infile, open(output_file, 'w') as outfile:
        write_line = False
        for line in infile:
            if line.startswith('#EXTM3U'):
                outfile.write(line)
            elif line.startswith('#EXTINF'):
                write_line = any(f'tvg-name="{channel}"' in line for channel in whitelist_channels)
                if write_line:
                    outfile.write(line)
            elif write_line:
                outfile.write(line)
                write_line = False

    print(f"Modifizierte M3U-Datei erstellt: {output_file}")
