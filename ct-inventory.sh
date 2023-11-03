#!/bin/bash

fname="ansible.env"
inventory="inv.d/cloud_inventory.py"

while getopts f:i: arg; do
		case $arg in
				f) fname="${OPTARG}";;
				i) inventory="${OPTARG}";;
				*) echo "ERROR :: invalid arg"; exit 42;;
		esac
done

if [[ -n "${fname}" ]]; then
	if [[ -r "${fname}" ]]; then
		source ${fname}
	fi
fi

${inventory}
exit 0
