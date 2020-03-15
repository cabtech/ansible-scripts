#!/bin/bash

here=$(pwd)
prog=$(basename $0)

ss_action='view'
ss_app=''
ss_save_original=true
ss_file=''
ss_seek=''
ss_vault_file="--vault-password-file=$here/.vault"
ss_verbose=false

while getopts F:SVa:def:g:hnsv arg; do
	case $arg in
		F) ss_vault_file="--vault-password-file=$OPTARG";;
		S) ss_save_original=false;;
		V) ss_vault_file='';;
		a) ss_action=${OPTARG};;
		d) ss_action='decrypt';;
		e) ss_action='encrypt';;
		f) ss_file=${OPTARG};;
		g) ss_action='grep'; ss_seek=${OPTARG};;
		h) echo "Usage: $prog [-SVdehnsv] [-F vault_file] [-a <decrypt|encrypt|view>] [-g grep_string] -f file"; exit 0;;
		n) ss_app=echo; ss_save_original=false;;
		s) ss_save_original=true;;
		v) ss_verbose=true;;
		*) echo "bad arg"; exit 42;;
	esac
done

# --------------------------------

if [[ -z "$ss_file" ]]; then
	echo "ERROR :: Need a file (-f)"
	exit 4
elif [[ ! -r "$ss_file" ]]; then
	echo "ERROR :: Cannot read $ss_file"
	exit 8
fi

# unsupported: create|edit|encrypt_string|rekey
# supported:   decrypt|encrypt|view

case $ss_action in
	d*) verb='decrypt';;
	e*) verb='encrypt';;
	grep) verb='grep';;
	v*) verb='view';;
	*) verb='view';;
esac

is_vaulted=false
head -1 $ss_file | grep -q ANSIBLE_VAULT
if (($?==0)); then
	is_vaulted=true
fi

# --------------------------------

if [[ "$verb" == "decrypt" ]]; then
	if $is_vaulted; then
		$app ansible-vault decrypt $ss_vault_file $ss_file
		if $ss_save_original; then
			/bin/cp $ss_file ORIG_DECRYPT_${ss_file}
		fi
	else
		echo "Not vaulted"
	fi

elif [[ "$verb" == "encrypt" ]]; then
	if $is_vaulted; then
		echo "Already vaulted"
	else
		$app ansible-vault encrypt $ss_vault_file $ss_file
	fi

elif [[ "$verb" == "grep" ]]; then
	if $is_vaulted; then
		$app ansible-vault view $ss_vault_file $ss_file | grep $ss_seek
	else
		grep $ss_seek $ss_file
	fi

elif [[ "$verb" == "view" ]]; then
	if $is_vaulted; then
		$app ansible-vault view $ss_vault_file $ss_file
	else
		cat $ss_file
	fi
else
	echo "Unexpected verb [$verb]"
fi

# --------------------------------

exit $?
