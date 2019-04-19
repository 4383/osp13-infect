#!/bin/sh
if [ $# -eq 0 ] 
then
    name=$1
else
    echo "Please provide a chassis name"
fi
address=$(niet "nodes[?name=='${name}'].pm_addr" /home/stack/instackenv.json)
port=$(niet "nodes[?name=='${name}'].pm_port" /home/stack/instackenv.json)
ipmitool -I lanplus -H ${address} -L ADMINISTRATOR -p ${port} -U admin -R 12 -N 5 -Ppassword power status
ipmitool -I lanplus -H ${address} -L ADMINISTRATOR -p ${port} -U admin -R 12 -N 5 -Ppassword power off
sleep 2
ipmitool -I lanplus -H ${address} -L ADMINISTRATOR -p ${port} -U admin -R 12 -N 5 -Ppassword power status
