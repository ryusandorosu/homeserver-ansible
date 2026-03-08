#!/bin/bash

jail_name="$1"
banned_ip="$2"
logpath="$3"
bantime="$4"
failures="$5"
ipfailures="$6"
ipjailfailures="$7"

if grep -m 20 -awF $banned_ip $logpath | grep -a "Restore Ban"; then exit 0; fi

BANTIME=" $(date -d@$bantime -u +%_H | sed 's/\ //') hours"
if (( $bantime >= 86400 )); then
BANTIME=" $(date -d@$bantime -u +%_d) days"
elif [[ $jail_name == recidive ]]; then
BANTIME="ever"
fi

MESSAGE="[Fail2Ban] <b>$jail_name</b>: banned <code>$banned_ip</code> from $(hostname) for<b>$BANTIME</b>
failures: $failures | ipfailures: $ipfailures | ipjailfailures: $ipjailfailures
<pre>$(curl -s http://ip-api.com/json/$banned_ip | jq)</pre>
logpath: <code>$logpath</code>
<pre>$(grep -m 20 -awF $banned_ip $logpath | grep -v ' sudo: ' | tail -n 20)</pre>"

/usr/local/bin/tgbot_notify.sh "$MESSAGE"
