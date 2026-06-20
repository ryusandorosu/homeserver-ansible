#!/usr/bin/env bash

template="$1"
[[ "$template" != */templates/* ]] && echo "error: only paths to template directories are allowed" && exit 1
[[ ! -f "$template" ]] && echo "error: template file does not exist" && exit 1
[[ ! -f ansible.cfg ]] && echo "error: the script must be run in a repo with ansible project" && exit 1

repo_root="$(git rev-parse --show-toplevel)"
relative_template="$(realpath --relative-to="$repo_root" "$template")"
# roles_root="$(awk -F/ -v r=$repo_root '/r/ {print $1}' <<< "$relative_template")"
# role="$(awk -F/ -v r=$roles_root '/r/ {print $2}' <<< "$relative_template")"
roles_root="$(echo "$relative_template" | cut -d/ -f1)"
role="$(echo "$relative_template" | cut -d/ -f2)"
outfile="$repo_root/${relative_template%.j2}"

ANSIBLE_BECOME_ASK_PASS=False \
ansible-playbook \
  "$repo_root/tools/render_template.yml" \
  -e template_path="$relative_template" \
  -e roles_dir="$roles_root" \
  -e role_name="$role" \
  -e output_path="$outfile"

OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2)
if [[ "$OS_ID" == debian ]]; then
  batcat "$outfile"
  rm "$outfile"
elif [[ "$OS_ID" == ubuntu ]]; then
  code "$outfile"
fi
