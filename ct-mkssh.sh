#!/bin/bash
# creates SSH config file (~/.ssh.config) from fragments (~/.ssh/cfg.d/*.cfg)

base=$( cd $(dirname $0)/.. && pwd)
prog=$(basename $0)

dotdir=~/.ssh
fragdir=$dotdir/cfg.d
config=$dotdir/config
tmpfile=/tmp/${prog}_$$

# --------------------------------

ss_doit=true
do_diffs=false
while getopts dsx arg; do
	case $arg in
		d) do_diffs=true;;
		s) ss_doit=false; do_diffs=true;;
		x) ss_doit=true;;
		*) echo 'bad arg - bye'; exit 42;;
	esac
done

if [[ ! -d "$dotdir" ]]; then
	echo "$prog :: ERROR :: cannot see $dot"
	exit 4
elif [[ ! -d "$fragdir" ]]; then
	echo "$prog :: ERROR :: cannot see $fragdir"
	exit 4
else
	chmod 700 $dotdir
	chmod 700 $fragdir
	chmod 600 $fragdir/*.cfg
	chmod 600 $config

	cat $fragdir/*.cfg > $tmpfile

	if $do_diffs; then
		diff $config $tmpfile
	fi
	if $ss_doit; then
		/bin/mv $tmpfile $config
	fi
	/bin/rm -f $tmpfile
	chmod 400 $config
fi

# --------------------------------

exit 0
