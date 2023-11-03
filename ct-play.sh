#!/bin/bash

base=$(cd $(dirname $0)/.. && pwd)
here=$(pwd)

ss_allow_all=false
ss_app=''
ss_bootstrap_all=false
ss_bootstrap_fname=""
ss_check='--check'
ss_debug=false
ss_diff=''
ss_extra=''
ss_forks='--forks=4'
ss_inventory=''
ss_limit=''
ss_play='site.yml'
ss_post_args=''
ss_pre_args=''
ss_skip=''
ss_vault_file="--vault-password-file=$here/.vault"
ss_virtualenv=''

force_check_mode=false # provide a means to force us back into check mode

while getopts ABDF:LNPQRV:abde:f:hi:l:np:r:s:t:vx arg; do
	case $arg in
		A) ss_pre_args="$ss_pre_args --ask-vault-pass"; ss_vault_file='';;
		B) ss_pre_args="$ss_pre_args --ask-become-pass";;
		D) ss_debug=true;;
		F) ss_vault_file="--vault-password-file=$OPTARG";;
		L) ss_pre_args="$ss_pre_args --list-tags --list-hosts"; force_check_mode=true;;
		N) ss_pre_args="$ss_pre_args --syntax-check";;
		P) ss_pre_args="$ss_pre_args --ask-pass";;
		Q) ansible --version; exit 0;;
		R) ss_vault_file='';;
		V) ss_virtualenv="$OPTARG";;
		a) ss_allow_all=true;;
		b) ss_bootstrap_all=true;;  # this means you source all the *.env files in your CWD
		d) ss_pre_args="$ss_pre_args --diff";;
		e) ss_extra="$OPTARG";;
		f) ss_forks="--forks=${OPTARG}";;
		h) echo 'need a help message'; exit 0;;
		i) ss_inventory=${OPTARG};;
		l) ss_limit=${OPTARG};;
		n) ss_app=echo;;
		p) ss_play=${OPTARG};;
		r) ss_bootstrap_fname="${OPTARG}";;  # this means you source a specific file
		s) ss_skip="--skip-tags=${OPTARG}";;
		t) ss_pre_args="$ss_pre_args --tags=${OPTARG}";;
		v) ss_pre_args="$ss_pre_args -v";;
		x) ss_check='';;
		*) echo "bad arg"; exit 42;;
	esac
done

if $force_check_mode; then
	ss_check='--check'
fi

# --------------------------------

if [[ -z "$ss_limit" ]]; then
	echo "ERROR :: Need a limit (-l)"
	exit 4
elif [[ -z "$ss_play" ]]; then
	echo "ERROR :: Need a play (-p)"
	exit 4
elif [[ ! -r "$ss_play" ]]; then
	echo "ERROR :: cannot read playbook $ss_play"
	exit 4
elif [[ "$ss_limit" == 'all' ]] && ! $ss_allow_all; then
	echo "ERROR :: Need to add '-a' to the command line if using '-l all'"
	exit 4
fi

if $ss_bootstrap_all; then
	check=$(/bin/ls -1 *.env 2> /dev/null)
	if [[ -n "$check" ]]; then
		for fname in *.env; do
			if [[ -r "$fname" ]]; then
				source $fname
			fi
		done
	fi
fi

if [[ -n "$ss_bootstrap_fname" ]]; then
	if [[ -r "$ss_bootstrap_fname" ]]; then
		source $ss_bootstrap_fname
	fi
fi

if [[ -n "$ss_inventory" ]]; then
	inv_dir=$(cd $(dirname $ss_inventory) && pwd)
	inv_stub=$(basename $ss_inventory)
	inventory="-i $inv_dir/$inv_stub"
else
	inventory=''
fi

play_dir=$(cd $(dirname $ss_play) && pwd)
play_stub=$(basename $ss_play)
orig_stub=$(basename $ss_play) # only used in output

if [[ "$play_dir" != "$here" ]]; then
	tmp_play=.ANSIBLE_PLAYBOOK_$$__${play_stub}
	cp $play_dir/$play_stub $tmp_play
	chmod 666 $tmp_play
	play_dir=$here
	play_stub=$tmp_play
	echo "PLAYBOOK [$orig_stub : copied to $tmp_play]"
	playbook_copied_over=true
else
	playbook_copied_over=false
fi

if [[ -n "$ss_extra" ]]; then
	ss_post_args="$ss_post_args --extra-vars=$ss_extra"
fi

# --------------------------------

if [[ -n "$ss_virtualenv" ]]; then
	if [[ -d "$ss_virtualenv" ]]; then
		source $ss_virtualenv/bin/activate
		echo "PLAYBOOK [$orig_stub : virtualenv ($ss_virtualenv)]"
	else
		echo "ERROR :: Could not see virtualenv at $ss_virtualenv"
		exit 66
	fi
fi

ansible_ver=$(ansible --version | grep "^ansible" | awk '{print $3}' | tr -d '[]')
python_ver=$(ansible --version | grep "python version" | awk -F' = ' '{print $2}' | awk '{print $1}')
echo "PLAYBOOK [$orig_stub : ansible $ansible_ver]"
echo "PLAYBOOK [$orig_stub : python $python_ver]"

# --------------------------------

if $ss_debug; then
	export ANSIBLE_KEEP_REMOTE_FILES=1
fi
if [[ -d "$here/library" ]]; then
	export ANSIBLE_LIBRARY=$here/library
fi

$ss_app ansible-playbook $ss_forks $ss_check $ss_vault_file $ss_pre_args $ss_skip -l $ss_limit $inventory $ss_post_args $play_dir/$play_stub

echo "PLAYBOOK [ $(basename $0) $* ]"

# --------------------------------
# clean up and exit

if $playbook_copied_over; then
	echo "PLAYBOOK [$orig_stub : Cleaning up local copy of $orig_stub]"
	/bin/rm -f $tmp_play
fi
echo ''
exit 0
