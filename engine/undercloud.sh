#!/bin/bash
set -x
BASEDIR=$(pwd)

cd /home/stack
echo ${BASEDIR}
source stackrc;

cat <<'EOF' >>~/.bashrc
# history navigation with arrows
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
source /usr/bin/infect-payload.sh
EOF


ansible-playbook ${BASEDIR}/playbooks/rhel-repos.yaml -vvv
