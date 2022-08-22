#!/bin/bash

prog=$(basename $0)

ss_workdir=''
ss_roles=''
while getopts r:w: arg; do
	case $arg in
		r) ss_roles="${OPTARG}";;
		w) ss_workdir="${OPTARG}";;
		*) echo "$prog :: ERROR :: bad arg"; exit 42;;
	esac
done

if [[ -z "${ss_workdir} " ]]; then
	echo "$prog: need a workdir"
	exit 4
elif [[ -z "${ss_roles} " ]]; then
	echo "$prog: need a role to point to"
	exit 8
elif [[ ! -d roles ]]; then
	echo "$prog: no roles dir"
	exit 12
else
	roles=${ss_roles//,/ }
	for role in $roles; do
		if [[ ! -h roles/$role ]]; then
			ln -s ${ss_workdir}/$role roles/$role
		fi
	done
fi

exit 0
