#!/bin/sh

UPDATES=$(apt list --upgradable 2>/dev/null | grep -c upgradable)

if [ "$UPDATES" -gt 0 ]; then
  echo "🔴 $UPDATES updates available"
else
  echo "🟢 System is up to date"
fi
