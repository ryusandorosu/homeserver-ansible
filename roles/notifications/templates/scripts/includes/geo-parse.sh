#!/bin/bash

geo_parse_ip_info() {
  country=$(echo "$1" | jq -r .country)
  region=$(echo "$1" | jq -r .regionName)
  city=$(echo "$1" | jq -r .city)
  timezone=$(echo "$1" | jq -r .timezone)
  asn="$(echo "$1" | jq -r .as)"
  lat=$(echo "$1" | jq -r .lat)
  lon=$(echo "$1" | jq -r .lon)
  geoip_json=$(echo "$1" | jq -r .status)
  [[ "$geoip_json" == "fail" ]] && geoip_msg="$(echo "$1" | jq -r .message)"
}
