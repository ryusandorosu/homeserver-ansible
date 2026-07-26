#!/bin/sh

white="\033[97m"
gray="\033[90m"
red="\033[91m"
green="\033[92m"
dark_green="\033[38;5;22m"
yellow="\033[33m"
black="\033[30m"
bg_white="\033[47m"
bg_gray="\033[48;5;243m"
nocolor="\033[0m"

print_highlighted() {
  local text="$1"
  local highlight="$2"
  local color="$3"
  echo "$text" | sed -E "s/${highlight}/$(printf $color)${highlight}$(printf $nocolor)/"
}
