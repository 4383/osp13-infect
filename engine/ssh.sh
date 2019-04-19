#!/bin/bash
set -x

BASEDIR=$(pwd)
function generate_ansible_host {
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
  User heat-admin
  StrictHostkeyChecking no
  UserKnownHostsFile /dev/null
EOF
chmod 600 ~/.ssh/config

nova list | grep controller > /tmp/controllers
#
generate_ansible_host
