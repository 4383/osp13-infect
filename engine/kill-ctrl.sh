#!/bin/sh
function infect_controller_ip_status () {
    if [ $# -eq 0 ] 
    then
        name=$1
    else
        echo "Please provide a chassis name"
    fi
    address=$(niet "nodes[?name=='${name}'].pm_addr" /home/stack/instackenv.json)
    port=$(niet "nodes[?name=='${name}'].pm_port" /home/stack/instackenv.json)
    ipmitool \
        -I lanplus \
        -H ${address} \
        -L ADMINISTRATOR \
        -p ${port} \
        -U admin -R 12 -N 5 -Ppassword power status
}

function infect_controller_ip_power_off () {
    if [ $# -eq 0 ] 
    then
        name=$1
    else
        echo "Please provide a chassis name"
    fi
    address=$(niet "nodes[?name=='${name}'].pm_addr" /home/stack/instackenv.json)
    port=$(niet "nodes[?name=='${name}'].pm_port" /home/stack/instackenv.json)
    infect_controller_ip_status ${name}
    ipmitool -I \
        lanplus -H ${address} -L ADMINISTRATOR -p ${port} \
        -U admin -R 12 -N 5 -Ppassword power off
    sleep 2
    infect_controller_ip_status ${name}
}
