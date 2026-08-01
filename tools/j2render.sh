#!/usr/bin/env bash

template="$1"
[[ "$template" != */templates/* ]] && echo "error: only paths to template directories are allowed" && exit 1
[[ ! -f "$template" ]] && echo "error: template file does not exist" && exit 1
[[ ! -f ansible.cfg ]] && echo "error: the script must be run in a repo with ansible project" && exit 1

repo_root="$(git rev-parse --show-toplevel)"
relative_template="$(realpath --relative-to="$repo_root" "$template")"
roles_root="$(echo "$relative_template" | cut -d/ -f1)"
role="$(echo "$relative_template" | cut -d/ -f2)"
outfile="$repo_root/${relative_template%.j2}"

# $2 is optional. defines jinja expression type for {{ item }}
item_pattern="$2"
item_arg="$3"
item_expr=""
case "$item_pattern" in
  # eg.: "nginx_public_sites[0]"  -- works
  list-index)
    var="${item_arg%% *}"; idx="${item_arg#* }"
    item_expr="${var}[${idx}]"
    ;;
  # eg.: "(nginx_private_sites | dict2items)[0]"
  dict2items-index)
    var="${item_arg%% *}"; idx="${item_arg#* }"
    item_expr="(${var} | dict2items)[${idx}]"
    ;;
  # eg.: "(nginx_private_sites | dict2items | selectattr('key','equalto','guac') | first)"
  dict2items-key)
    var="${item_arg%% *}"; key="${item_arg#* }"
    item_expr="(${var} | dict2items | selectattr('key','equalto','${key}') | first)"
    ;;
  none|"")
    item_expr=""
    ;;
esac
extra_item_arg=()
[[ -n "$item_expr" ]] && extra_item_arg=(-e "item={{ $item_expr }}")

ANSIBLE_BECOME_ASK_PASS=False \
ansible-playbook \
  "$repo_root/tools/render_template.yml" \
  -e template_path="$relative_template" \
  -e roles_dir="$roles_root" \
  -e role_name="$role" \
  -e output_path="$outfile" \
  "${extra_item_arg[@]}" \
  --tags always,vars

OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2)
if [[ "$OS_ID" == debian ]]; then
  bat "$outfile"
  rm "$outfile"
elif [[ "$OS_ID" == ubuntu ]]; then
  code "$outfile"
fi
