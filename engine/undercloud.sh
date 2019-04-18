#!/bin/bash
BASEDIR=$(pwd)

cd /home/stack
echo ${BASEDIR}
source stackrc;

cat <<'EOF' >>~/.bashrc
# history navigation with arrows
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
EOF

sudo cat /etc/ansible/hosts

ansible all -m ping
ansible-playbook ${BASEDIR}/playbooks/rhel-repos.yaml
