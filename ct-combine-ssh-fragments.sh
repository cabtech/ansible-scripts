#!/bin/bash

base=$( cd $(dirname $0)/.. && pwd)
prog=$(basename $0)

dot=~/.ssh
fragdir=$dot/cfg.d
cfg=$dot/config
tmp=/tmp/${prog}_$$

# --------------------------------

ss_doit=true
do_diffs=false
while getopts ds arg; do
	case $arg in
		d) do_diffs=true;;
		s) ss_doit=false; do_diffs=true;;
		*) echo 'bad arg - bye'; exit 42;;
	esac
done

if [[ ! -d "$dot" ]]; then
	echo "$prog :: ERROR :: cannot see $dot"
	exit 4
elif [[ ! -d "$fragdir" ]]; then
	echo "$prog :: ERROR :: cannot see $fragdir"
	exit 4
else
	chmod 700 $dot
	chmod 700 $fragdir
	chmod 600 $fragdir/*.cfg
	chmod 600 $cfg

	cat $fragdir/*.cfg > $tmp

	if $do_diffs; then
		diff $cfg $tmp
	fi
	if $ss_doit; then
		/bin/mv $tmp $cfg
	fi
	chmod 400 $cfg
fi

# --------------------------------

/bin/rm -f $tmp
exit 0
