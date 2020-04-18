#!/bin/bash

# provides the equivalent of 'ansible-vault decrypt_string'

ss_args='--vault-password-file=.vault'
ss_fname=''
do_verbose=false
while getopts Pf:p:v arg; do
	case $arg in
		P) ss_args='';;
		f) ss_fname="${OPTARG}";;
		p) ss_args="--vault-password-file=${OPTARG}";;
		v) do_verbose=true;;
		*) echo 'bad arg - exiting'; exit 42;;
	esac
done

if [[ -z "$ss_fname" ]]; then
	echo "Need a filename (-f)"
	exit 4
elif [[ ! -r "$ss_fname" ]]; then
	echo "Cannot read $ss_fname"
	exit 4
else
	if $do_verbose; then
		egrep -v '\-\-\-|\.\.\.|vault' $ss_fname | sed 's/^ *//'
		echo "egrep -v '\-\-\-|\.\.\.|vault' $ss_fname | sed 's/^ *//' | ansible-vault decrypt $ss_args 2>/dev/null"
	fi
	egrep -v '\-\-\-|\.\.\.|vault' $ss_fname | sed 's/^ *//' | ansible-vault decrypt $ss_args 2>/dev/null
fi

exit 0
