#!/usr/bin/env bash

# set -euo pipefail

template="$1"
[[ "$template" != */templates/* ]] && echo "error: only paths to template directories are allowed" && exit 1
[[ ! -f "$template" ]] && echo "error: template file does not exist" && exit 1
roles_root="$(cut -d'/' -f1 <<< "$template")"

repo_root="$(git rev-parse --show-toplevel)"
relative_template="$(realpath --relative-to="$repo_root" "$template")"
role="$(awk -F/ -v r=$roles_root '/r/ {print $2}' <<< "$relative_template")"
# outfile="/tmp/$(basename "${template%.j2}")"
outfile="$repo_root/${relative_template%.j2}"

# ANSIBLE_BECOME=False \
ANSIBLE_BECOME_ASK_PASS=False \
ansible-playbook \
  "$repo_root/tools/render_template.yml" \
  -e template_path="$relative_template" \
  -e roles_dir="$roles_root" \
  -e role_name="$role" \
  -e output_path="$outfile"

OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2)
[[ "$OS_ID" == debian ]] && batcat "$outfile"
[[ "$OS_ID" == ubuntu ]] && code "$outfile"
