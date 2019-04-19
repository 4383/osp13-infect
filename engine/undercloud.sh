#!/bin/bash
set -x
BASEDIR=$(pwd)

cd /home/stack
echo ${BASEDIR}
source stackrc;

cat ${BASEDIR}/bashrc >> ~/.bashrc

ansible-playbook ${BASEDIR}/playbooks/rhel-repos.yaml -vvv
