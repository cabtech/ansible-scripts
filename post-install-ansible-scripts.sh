#!/bin/bash
base=$(cd $(dirname $0) && pwd)
cp $base/ct-*.sh /usr/local/bin
cp $base/ansible.inc /usr/local/etc/bash.d/ansible.sh
chmod 644 /usr/local/etc/bash.d/ansible.sh
exit 0
