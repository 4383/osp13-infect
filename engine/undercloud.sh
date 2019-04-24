#!/bin/bash
set -x
BASEDIR=$(pwd)

cd /home/stack
echo ${BASEDIR}
source stackrc;
source /usr/bin/infect-payload.sh

cat ${BASEDIR}/bashrc >> ~/.bashrc

ansible-playbook ${BASEDIR}/playbooks/rhel-repos.yaml
infect_conf_backup
