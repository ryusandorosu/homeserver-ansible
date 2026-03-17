#!/bin/bash

geo_message_common() {
local IP="$1"
local IP_INFO="$2"
local LOG="$3"
local KEY="$4"
local DEVICE="$5"
local VPN_IP="$6"
MESSAGE+="From: <code>$IP</code>
"
[[ -n "$DEVICE" ]] && MESSAGE+="Device: <b>$DEVICE</b>"
[[ -n "$DEVICE" && -n "$VPN_IP" ]] && MESSAGE+=" as <code>$VPN_IP</code>"
MESSAGE+="<pre>$(echo "$IP_INFO" | jq)</pre>"
geo_map_link "$lat" "$lon"
MESSAGE+="Check log: <code>$LOG</code>
<pre>$(log_tail "$KEY" "$LOG")</pre>"
}

geo_map_link() {
MESSAGE+="Location: <a href='https://2gis.ru/geo/$2%2C$1'>2GIS</a> | <a href='https://maps.google.com/?q=$1,$2'>Google Maps</a>
"
}
