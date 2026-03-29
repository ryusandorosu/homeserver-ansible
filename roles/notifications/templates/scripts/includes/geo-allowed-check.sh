#!/bin/bash

geo_message_allowed_check() {
not_allowed_flag=false

local IP="$1"
for subnet in "${allowed_subnets[@]}"; do
  if [[ "$(ip_in_subnet "$IP" "$subnet")" == "True" ]]; then
    allowed_subnet=true
    break
  else
    allowed_subnet=false
  fi
done

if [[ "$allowed_subnet" == false ]]; then
MESSAGE+="⚠️ Connection from the different subnet
"; not_allowed_flag=true; fi

[[ "$geoip_json" == "fail" && \
   "$geoip_msg" == "private range" ]] && return

if [[ ! " ${allowed_countries[*]} " =~ " ${country} " ]]; then
MESSAGE+="⚠️ Connection from the different country
"; not_allowed_flag=true; fi

if [[ ! " ${allowed_regions[*]} " =~ " ${region} " ]]; then
MESSAGE+="⚠️ Connection from the different region
"; not_allowed_flag=true; fi

if [[ ! " ${allowed_asn[*]} " =~ " ${asn} " ]]; then
MESSAGE+="⚠️ Connection from the different ASN
"; not_allowed_flag=true; fi

}
