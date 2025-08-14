#!/bin/bash
# Local storage path for the JSON file
LOCAL_JSON_FILE="_tdt-tv.json"
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

# @see: https://github.com/iptv-org/iptv/commit/9302f7fe04f570d53a38b7234d3e95a1d298b947#diff-299e6c124f1e02a3d51557243b1417364c1921684e86824122c117d7fbe56a8dR16-R17
echo '#EXTINF:-1 tvg-id="null" tvg-name="Tlnovelas Europa" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/6/62/Tlnovelas_logo_2021.png" group-title="Int. Europa",Tlnovelas Europa' >> "${M3U_FILE}"
echo 'https://televisa-televisa-1-it.samsung.wurl.tv/playlist.m3u8' >> "${M3U_FILE}"
# @see: https://github.com/iptv-org/iptv/commit/9302f7fe04f570d53a38b7234d3e95a1d298b947#diff-299e6c124f1e02a3d51557243b1417364c1921684e86824122c117d7fbe56a8dR11-R12
echo '#EXTINF:-1 tvg-id="null" tvg-name="MyTime movie network Mexico" tvg-logo="https://graph.facebook.com/mytimemovienetwork/picture?width=200&height=200" group-title="Int. América",MyTime movie network Mexico' >> "${M3U_FILE}"
echo 'https://appletree-mytime-samsungmexico.amagi.tv/playlist.m3u8' >> "${M3U_FILE}"
# @see: https://github.com/dmelendez11/lista-canales-m3u/blob/main/canales.m3u
echo '#EXTINF:-1 tvg-id="null" tvg-name="PASIONES" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Pasiones_Tv_logo.svg/320px-Pasiones_Tv_logo.svg.png" group-title="Novelas",PASIONES' >> "${M3U_FILE}"
echo 'http://179.51.136.19:8000/play/a1bv/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="Pasiones HD" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Pasiones_Tv_logo.svg/320px-Pasiones_Tv_logo.svg.png" group-title="Novelas",Pasiones HD' >> "${M3U_FILE}"
echo 'http://45.176.71.20:1689/play/a0nt' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="TNT Novelas" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/TNT_Logo_2016.svg/250px-TNT_Logo_2016.svg.png" group-title="Novelas",TNT Novelas' >> "${M3U_FILE}"
echo 'http://200.60.124.19:29000/play/a06r' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="KANAL D DRAMA" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/d/de/Kanal_D_%281991-1994%29.png" group-title="Novelas",KANAL D DRAMA' >> "${M3U_FILE}"
echo 'https://cdn-uw2-prod.tsv2.amagi.tv/linear/amg01602-themahqfrance-vivekanald-samsungspain/playlist.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="Golden" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/b/bb/Golden_logo.png" group-title="Películas",Golden' >> "${M3U_FILE}"
echo 'http://181.119.85.222:8000/play/a00u/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="Golden Premiere" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/b/bb/Golden_logo.png" group-title="Películas",Golden Premiere' >> "${M3U_FILE}"
echo 'http://200.125.170.122:8000/play/a00l' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="Cine Canal" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/CinecanalLA.png/330px-CinecanalLA.png" group-title="Películas",Cine Canal' >> "${M3U_FILE}"
echo 'http://181.119.86.68:8000/play/b036/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="Cine Max" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Cinemax_%28Yellow%29.svg/330px-Cinemax_%28Yellow%29.svg.png" group-title="Películas",Cine Max' >> "${M3U_FILE}"
echo 'http://181.78.201.70:8000/play/a0hi/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="FX" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/FX_International_logo.svg/330px-FX_International_logo.svg.png" group-title="Películas",FX' >> "${M3U_FILE}"
echo 'http://181.119.85.222:8000/play/a00s/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="De Pelicula" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/DPel%C3%ADcula_2021_%282%29.svg/258px-DPel%C3%ADcula_2021_%282%29.svg.png" group-title="Películas",De Pelicula' >> "${M3U_FILE}"
echo 'http://181.119.85.222:8000/play/a013/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="SONY MOVIES HD" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Sony_Movies_Logo.svg/250px-Sony_Movies_Logo.svg.png" group-title="Películas",SONY MOVIES HD' >> "${M3U_FILE}"
echo 'http://179.51.136.19:8000/play/a1aa/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="SPACE" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/SpaceLogo.svg/330px-SpaceLogo.svg.png" group-title="Películas",SPACE' >> "${M3U_FILE}"
echo 'http://181.78.106.127:9000/play/ca072/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="STAR" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Star_Channel_Greece_logo.svg/330px-Star_Channel_Greece_logo.svg.png" group-title="Películas",STAR' >> "${M3U_FILE}"
echo 'http://181.119.86.68:8000/play/b014/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="STAR CHANNEL SD" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Star_Channel_Greece_logo.svg/330px-Star_Channel_Greece_logo.svg.png" group-title="Películas",STAR CHANNEL SD' >> "${M3U_FILE}"
echo 'http://200.60.124.19:29000/play/a01r' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="STUDIO UNIVERSAL" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Logo_Studio_Universal.svg/330px-Logo_Studio_Universal.svg.png" group-title="Películas",STUDIO UNIVERSAL' >> "${M3U_FILE}"
echo 'http://181.119.86.68:8000/play/c024/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="TCM" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/TCM_logo.svg/330px-TCM_logo.svg.png" group-title="Películas",TCM' >> "${M3U_FILE}"
echo 'http://200.60.124.19:29000/play/a01s/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="TNT" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/TNT_Logo_2016.svg/250px-TNT_Logo_2016.svg.png" group-title="Películas",TNT' >> "${M3U_FILE}"
echo 'http://179.51.136.19:8000/play/a1af/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="TNT SERIES" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/7/75/TNT_Series_Logo_2016.png" group-title="Series",TNT SERIES' >> "${M3U_FILE}"
echo 'http://179.51.136.19:8000/play/a1al/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="Universal TV" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Universal_TV_logo.svg/320px-Universal_TV_logo.svg.png" group-title="Series",Universal TV' >> "${M3U_FILE}"
echo 'http://181.119.85.222:8000/play/a00x/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="Warner HD" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Warner2018LA.png/330px-Warner2018LA.png" group-title="Películas",Warner HD' >> "${M3U_FILE}"
echo 'http://179.51.136.19:8000/play/a0wx/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="SONY HD" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/b/b9/Sony_Channel_Logo.png" group-title="Películas",SONY HD' >> "${M3U_FILE}"
echo 'http://181.119.86.68:8000/play/c023/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="AMC" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/AMC_logo_2019.svg/330px-AMC_logo_2019.svg.png" group-title="Películas",AMC' >> "${M3U_FILE}"
echo 'http://181.78.106.127:9000/play/ca080/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="AXN HD" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/AXN_logo_%282015%29.svg/330px-AXN_logo_%282015%29.svg.png" group-title="Películas",AXN HD' >> "${M3U_FILE}"
echo 'http://181.119.85.222:8000/play/a01y/index.m3u8' >> "${M3U_FILE}"
echo '#EXTINF:-1 tvg-id="null" tvg-name="PARAMOUNT" tvg-logo="https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Paramount_Skydance_Corporation_Logo.svg/330px-Paramount_Skydance_Corporation_Logo.svg.png" group-title="Películas",PARAMOUNT' >> "${M3U_FILE}"
echo 'http://179.51.136.19:8000/play/a1am/index.m3u8' >> "${M3U_FILE}"


echo "M3U playlist has been created: ${M3U_FILE}"
