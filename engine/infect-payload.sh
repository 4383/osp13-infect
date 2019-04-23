#!/bin/sh
function infect_controller_ipmi_status () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a chassis name"
        return 1
    fi
    name=$1
    info=$(niet "nodes[?name=='${name}']" /home/stack/instackenv.json -f json)
    address=$(niet "nodes[?name=='${name}'].pm_addr" /home/stack/instackenv.json)
    port=$(niet "nodes[?name=='${name}'].pm_port" /home/stack/instackenv.json)
    if [ $# -lt 2 ] # minimal mode
    then
        echo -e "IPMI Contoller infos:\n\tname=${name}\n\taddress=${address}\n\tport=${port}"
        echo -e "${info}"
    fi
    ipmitool \
        -I lanplus \
        -H ${address} \
        -L ADMINISTRATOR \
        -p ${port} \
        -U admin -R 12 -N 5 -Ppassword power status
}

function infect_controller_ipmi_power_off () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a chassis name"
        return 1
    fi
    name=$1
    address=$(niet "nodes[?name=='${name}'].pm_addr" /home/stack/instackenv.json)
    port=$(niet "nodes[?name=='${name}'].pm_port" /home/stack/instackenv.json)
    infect_controller_ipmi_status ${name}
    ipmitool -I \
        lanplus -H ${address} -L ADMINISTRATOR -p ${port} \
        -U admin -R 12 -N 5 -Ppassword power off
    sleep 2
    infect_controller_ipmi_status ${name} quiet
}

function infect_controller_ipmi_power_on () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a chassis name"
        return 1
    fi
    name=$1
    address=$(niet "nodes[?name=='${name}'].pm_addr" /home/stack/instackenv.json)
    port=$(niet "nodes[?name=='${name}'].pm_port" /home/stack/instackenv.json)
    infect_controller_ipmi_status ${name}
    ipmitool -I \
        lanplus -H ${address} -L ADMINISTRATOR -p ${port} \
        -U admin -R 12 -N 5 -Ppassword power on
    sleep 2
    infect_controller_ipmi_status ${name} quiet
}

function infect_controller_ipmi_reboot () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a chassis name"
        return 1
    fi
    name=$1
    address=$(niet "nodes[?name=='${name}'].pm_addr" /home/stack/instackenv.json)
    port=$(niet "nodes[?name=='${name}'].pm_port" /home/stack/instackenv.json)
    infect_controller_ipmi_status ${name}
    ipmitool -I \
        lanplus -H ${address} -L ADMINISTRATOR -p ${port} \
        -U admin -R 12 -N 5 -Ppassword power off
    sleep 2
    infect_controller_ipmi_status ${name} quiet
    ipmitool -I \
        lanplus -H ${address} -L ADMINISTRATOR -p ${port} \
        -U admin -R 12 -N 5 -Ppassword power on
    sleep 2
    infect_controller_ipmi_status ${name} quiet
}

function infect_pcs_status_from_undercloud () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a controller name"
        return 1
    fi
    name=$1
    ssh -t ${name} 'sudo -i pcs status'
}

function infect_controller_status () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a controller name"
        return 1
    fi
    name=$1
    ssh -t ${name} 'sudo -i crm_simulate -sL'
    ssh -t ${name} 'sudo -i crm_mon -1'
}

function infect_debug_rabbit () {
    if [ $# -lt 2 ]
    then
        echo "Please provide a controller name and a time since"
        return 1
    fi
    name=$1
    since=$2
    echo "Debuging rabbit on ${name} since ${since}"
    ssh -t ${name} "sudo -i journalctl --since ${since} | grep rabbitmq | less"
}

function infect_turn_debug_on () {
    return 0
}

function infect_get_default_log_level () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a controller name"
        return 1
    fi
    name=$1
    project=""
    if [ $# -gt 1 ]
    then
        project=$2
    fi
    ssh -t ${name} "sudo -i grep -ri /etc/${project} -e 'default_log_level'"
}

function infect_get_oslo_conf () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a controller name"
        return 1
    fi
    name=$1
    project=""
    if [ $# -gt 1 ]
    then
        project=$2
    fi
    ssh -t ${name} "sudo -i grep -ri /etc/${project} -e 'oslo'"
}

function infect_list_containers () {
    docker ps --format "{{.Names}}"
}

function infect_configure_containers_repos () {
    for container in $(infect_list_containers)
    do
        echo "Infect ${container}"
        docker exec --user root -it ${container} rm -rf /etc/yum.repos.d
        docker exec --user root -it ${container} mkdir /etc/yum.repos.d
        current=$(pwd)
        cd /etc/
        tar -c -v -f - /etc/yum.repos.d | docker exec --user root -i ${container} bash -c 'tar -x -v --strip-components 1 --directory=/etc/ ' -
        cd $current
    done
}

function infect_install_base_apps_on_containers () {
    for container in $(infect_list_containers)
    do
        docker exec --user root -it ${container} bash -l -c "yum install -y git"
        docker exec --user root -it ${container} bash -l -c "yum install -y vim"
        docker exec --user root -it ${container} bash -l -c "yum install -y gdb"
    done
}

function infect_install_on_containers () {
    if [ $# -lt 2 ] 
    then
        echo "Please provide container name"
        return 1
    fi
    container=$1
    apps=$2
    docker exec -it ${container} yum install -y ${apps}
}

function infect_who_use_oslo () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide oslo project name"
        return 1
    fi
    name=$1
    for container in $(infect_list_containers)
    do
        docker exec -it ${container} test -d /usr/lib/python2.7/site-packages/oslo_${name} && echo ${container}
    done
}

function infect_who_use_this_python_module () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide module name"
        return 1
    fi
    name=$1
    for container in $(infect_list_containers)
    do
        docker exec -it ${container} test -d /usr/lib/python2.7/site-packages/${name} && echo ${container}
    done
}

function infect_all_packages_versions () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a container name"
        return 1
    fi
    name=$1
    docker exec -it ${name} rpm -qa
}

function infect_given_packages_versions () {
    if [ $# -lt 2 ] 
    then
        echo "Please provide a container name and package name"
        echo 'usage: given_packages_versions nova_api "oslo_messaging|amqp"'
        return 1
    fi
    name=$1
    packages=$2
    docker exec -it ${name} rpm -qa | grep -E "${packages}"
}
