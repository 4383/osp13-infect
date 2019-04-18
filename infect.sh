#!/bin/bash
SSHCONF=./engine/ssh-config
SSH="ssh -F $SSHCONF undercloud"
SCP="scp -F $SSHCONF"

${SSH} 'yum install -y vim git gdb'
${SSH} 'python -m ensurepip'
${SSH} 'python -m pip install niet'
${SSH} 'su - stack sh -l -c "git clone https://gitlab.cee.redhat.com/hberaud/osp13-infect.git"'
${SSH} 'su - stack sh -l -c "cd osp13-infect/engine && ./undercloud.sh"'
