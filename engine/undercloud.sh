#!/bin/bash
cd /home/stack

yum install -y vim gdb

cd /home/stack
mkdir ~/.ssh | /bin/true
chmod 0700 ~/.ssh

cat > ~/.ssh/config <<EOF
Host *
  User heat-admin
  StrictHostkeyChecking no
  UserKnownHostsFile /dev/null
EOF
chmod 600 ~/.ssh/config

CONTROLLERS=$(nova list | grep "controller" | )
echo "[controllers]" > hostfile
for controller in "${CONTROLLERS}"
do
    name=$(${controller} | awk '{print $6}')
    ip=$(${controller} | awk '{print $12}' | awk -F "=" '{print $2}')
    echo "${name} ansible_host=${ip} ansible_user=heat-admin" >> hostfile
done

ansible --inventory-file=hostfile -m ping
