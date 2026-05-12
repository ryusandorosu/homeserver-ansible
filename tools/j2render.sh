#!/usr/bin/env bash

# set -euo pipefail

template="$1"
repo_root="$(git rev-parse --show-toplevel)"
relative_template="$(realpath --relative-to="$repo_root" "$template")"
role="$(awk -F/ '/roles/ {print $2}' <<< "$relative_template")"
# outfile="/tmp/$(basename "${template%.j2}")"
outfile="$repo_root/${relative_template%.j2}"

# ANSIBLE_BECOME=False \
ANSIBLE_BECOME_ASK_PASS=False \
ansible-playbook \
  "$repo_root/tools/render_template.yml" \
  -e template_path="$relative_template" \
  -e role_name="$role" \
  -e output_path="$outfile"

code "$outfile"
