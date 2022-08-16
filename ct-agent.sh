#!/bin/bash
# kills old SSH agent and launches a new one
# saves details so they can be sourced by future shells

uid=$(id -u)
fname=~/etc/bash.d/ssh-agent.sh
pgrep ssh-agent
pkill -u $uid ssh-agent
pgrep ssh-agent
ssh-agent | grep -v 'echo Agent pid' > $fname
echo "source $fname"
exit 0
