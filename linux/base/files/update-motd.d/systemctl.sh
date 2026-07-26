#!/bin/sh
red='\033[91m'
nocolor='\033[0m'

print_highlighted() {
  local text="$1"
  local highlight="$2"
  local color="$3"
  echo "$text" | sed -E "s/${highlight}/$(printf $color)${highlight}$(printf $nocolor)/"
}

print_highlighted "$(systemctl --state=failed --quiet)" ● "${red}"
