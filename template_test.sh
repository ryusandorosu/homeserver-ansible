#!/bin/bash

role=$1
file=$2
defaults=$(find "roles/$role/defaults/" -type f -name "main.yml")
template=$(find "roles/$role/templates/" -type f -name "$file.j2")

test_playbook=test.yml
touch $test_playbook
test_file=$(basename "$template" | sed 's/\.j2//')

echo "
- hosts: localhost
  connection: local
  vars_files:
    - $defaults

  tasks:
    - template:
        src: $template
        dest: $test_file
" > $test_playbook

ansible-playbook $test_playbook && batcat $test_file
rm $test_playbook $test_file
