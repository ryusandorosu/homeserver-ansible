#!/bin/bash
. /usr/local/bin/get_ip_geo.sh
jail_name="$1"
banned_ip="$2"
logpath="$3"
bantime="$4"
failures="$5"
ipfailures="$6"
ipjailfailures="$7"

loglines=20
if grep -m $loglines -awF $banned_ip /var/log/fail2ban.log | grep -aE "Restore Ban|already banned"; then exit 0; fi

BANTIME=" $(date -d@$bantime -u +%_H | sed 's/\ //') hours"
(( $bantime >= 86400 )) && BANTIME=" $(date -d@$bantime -u +%_d) days"
(( $bantime >= 2678400 )) && BANTIME=" $(date -d@$bantime -u +%_d) months"
[[ "$BANTIME" =~ ^\ 1\ (hours|days|months)$ ]] && BANTIME=${BANTIME%s}
(( $bantime == -1 )) && BANTIME="ever"

MESSAGE="[Fail2Ban] <b>$jail_name</b>: banned <code>$banned_ip</code> from $(hostname) for<b>$BANTIME</b> (debug: $bantime)
failures: $failures | ipfailures: $ipfailures | ipjailfailures: $ipjailfailures
<pre>$(get_ip_geo $banned_ip | jq)</pre>
logpath: <code>$logpath</code>
<pre>$(grep -m $loglines -awF $banned_ip $logpath | grep -v ' sudo: ' | tail -n $loglines)</pre>"

/usr/local/bin/tgbot_notify.sh "$MESSAGE"
