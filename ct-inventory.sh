#!/bin/bash

fname="ansible.env"
inventory="inv.d/cloud_inventory.py"

while getopts i:r: arg; do
		case $arg in
				i) inventory="${OPTARG}";;
				r) fname="${OPTARG}";;  # same arg as ct-play.sh
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
