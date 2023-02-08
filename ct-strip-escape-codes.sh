#!/bin/bash
if [[ -t 0 ]]; then
	cat $1 | $0
else
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"
fi
exit 0
