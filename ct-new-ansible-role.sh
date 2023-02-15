#!/bin/bash
mkdir -p .config defaults files handlers meta tasks templates

echo "git add Makefile .config/* meta/main.yml"

cat << ENDCAT > Makefile
lint:
	yamllint.sh .
	ansible-lint
ENDCAT


cat << ENDCAT > meta/main.yml
---
dependencies: []
...
ENDCAT

cat << ENDCAT > .config/yamllint
---
extends: default

rules:
  line-length:
    level: warning
    max: 1024
  indentation:
    spaces: 2
    indent-sequences: false
...
ENDCAT

cat << ENDCAT > .config/ansible-lint.yml
---
exclude_paths:
- ../playbooks
skip_list:
- meta-no-info
- role-name
- yaml[indentation]
...
ENDCAT

exit 0
