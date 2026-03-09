#!/bin/bash
. /usr/local/bin/get_ip_geo.sh
jail_name="$1"
banned_ip="$2"
logpath="$3"
bantime="$4"
failures="$5"
ipfailures="$6"
ipjailfailures="$7"

if [[ $logpath != /var/log/fail2ban.log ]]; then
  if grep -m 20 -awF $banned_ip /var/log/fail2ban.log | grep -a "Restore Ban"; then exit 0; fi
else
  if grep -m 20 -awF $banned_ip $logpath | grep -a "Restore Ban"; then exit 0; fi
fi

BANTIME=" $(date -d@$bantime -u +%_H | sed 's/\ //') hours"
(( $bantime >= 86400 )) && BANTIME=" $(date -d@$bantime -u +%_d) days"
[[ $jail_name == recidive ]] && BANTIME="ever"

MESSAGE="[Fail2Ban] <b>$jail_name</b>: banned <code>$banned_ip</code> from $(hostname) for<b>$BANTIME</b>
failures: $failures | ipfailures: $ipfailures | ipjailfailures: $ipjailfailures
<pre>$(get_ip_geo $banned_ip)</pre>
logpath: <code>$logpath</code>
<pre>$(grep -m 20 -awF $banned_ip $logpath | grep -v ' sudo: ' | tail -n 20)</pre>"

/usr/local/bin/tgbot_notify.sh "$MESSAGE"
