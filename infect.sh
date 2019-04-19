#!/bin/bash
set -x
SSHCONF=./engine/ssh-config
SSH="ssh -t -F $SSHCONF undercloud"
SCP="scp -F $SSHCONF"

python -m pip install niet
${SSH} 'yum install -y vim git gdb bash ansible'
${SSH} 'su - stack bash -l -c "test -d osp13-infect && rm -rf osp13-infect"'
${SSH} 'su - stack bash -l -c "git clone https://github.com/4383/osp13-infect.git"'
${SSH} 'cp /home/stack/ops13-infect/engine/kill-ctrl.sh /usr/bin/kill-ctrl'
${SSH} 'su - stack bash -l -c "cd osp13-infect/engine && ./ssh.sh"'
${SSH} 'cat /home/stack/tmp/ansible-host-out >> /etc/ansible/hosts'
${SSH} 'su - stack bash -l -c "cd osp13-infect/engine && ./undercloud.sh"'
