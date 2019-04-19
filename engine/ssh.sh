#!/bin/bash
set -x

BASEDIR=$(pwd)
function infect_generate_ansible_host {
    python ${BASEDIR}/ansible_host.py
}

cd /home/stack
echo ${BASEDIR}
source stackrc;
mkdir tmp/

cd /home/stack
mkdir ~/.ssh | /bin/true
chmod 0700 ~/.ssh

cat >> ~/.ssh/config <<EOF
Host *
  StrictHostkeyChecking no
  UserKnownHostsFile /dev/null
EOF
chmod 600 ~/.ssh/config

nova list | grep controller > /tmp/controllers
#
infect_generate_ansible_host
