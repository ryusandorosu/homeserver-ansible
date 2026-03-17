#!/bin/bash

ip_in_subnet() {
local IP="$1"
local SUBNET="$2"
python3 - <<EOF
import ipaddress
print(ipaddress.ip_address("$IP") in ipaddress.ip_network("$SUBNET", strict=False))
EOF
}
