#!/bin/sh

UPDATES="$(apt list --upgradable 2>/dev/null | tail -n +2)"
COUNT=$(printf "%s\n" "$UPDATES" | grep -c .)

if [ "$COUNT" -gt 0 ]; then
  echo "🔴 $COUNT updates available:"
  printf "%s\n" "$UPDATES"
else
  echo "🟢 System is up to date"
fi
