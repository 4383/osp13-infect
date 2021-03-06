#!/bin/sh
function infect_find_log_archives_on_controller () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a controller name"
        return 1
    fi
    controller=$1
    ssh -q ${controller} 'sudo -i find /var/log/containers/ -type f -iname *.log.*'
}

function infect_remove_logs_archives_on_all_controllers () {
    for controller in $(cat /home/stack/osp13-infect/controllers)
    do
        for file in $(infect_find_log_archives_on_controller ${controller})
        do
            echo "remove ${file} on ${controller}"
            ssh -q ${controller} "sudo -i rm -rf ${file}"
        done
    done
}

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
    ssh ${name} 'sudo -i pcs status'
}

function infect_controller_status () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a controller name"
        return 1
    fi
    name=$1
    ssh ${name} 'sudo -i crm_simulate -sL'
    ssh ${name} 'sudo -i crm_mon -1'
}

function infect_restore_config () {
    filestopatch=$(infect_list_conf_files)
    for control in $(cat /home/stack/osp13-infect/controllers)
    do
        for project in $(echo ${filestopatch})
        do
            echo "turn on ${control} => ${project}"
            echo $modified
            ssh -q ${control} "echo '${modified}' | sudo -i tee -a ${project}"
        done
    done
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
    ssh ${name} "sudo -i journalctl --since ${since} | grep rabbitmq | less"
}

function infect_list_conf_files () {
    if [ $# -eq 0 ] 
    then
        controller=$(head -1 osp13-infect/controllers)
    else
        controller=$1
    fi
    ssh -q ${controller} 'sudo -i grep -ri /etc -e "default_log_level" -l --exclude=*.backup'
}

function infect_list_backup_files () {
    if [ $# -eq 0 ] 
    then
        controller=$(head -1 osp13-infect/controllers)
    else
        controller=$1
    fi
    ssh -q ${controller} 'sudo -i find /etc/ -type f -iname *.backup 2>/dev/null'
}

function infect_restore_config () {
    filestopatch=$(infect_list_conf_files)
    for controller in $(cat /home/stack/osp13-infect/controllers)
    do
        backups=$(ssh -q ${controller} 'sudo -i find /etc/ -type f -iname *.backup 2>/dev/null')
        for backup in ${backups}
        do
            echo "restore on ${controller} => ${project}"
            original=$(echo ${backup} | sed 's@.backup@@g')
            ssh -q ${controller} "sudo -i cp --preserve ${backup} ${original}"
        done
    done
}

function infect_retrieve_rabbit () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a controller name"
        return 1
    fi
    name=$1
    ssh -q -t ${name} 'sudo -i docker ps --format "{{.Names}}" | grep rabbit'
}

function infect_rabbitmq_cluster_status () {
    if [ $# -eq 0 ] 
    then
        controller=$(head -1 osp13-infect/controllers)
    else
        controller=$1
    fi
    rabbit=$(infect_retrieve_rabbit ${controller})
    echo "Analyzing ${rabbit} on ${controller}"
    ssh -q -t ${controller} "sudo -i docker exec -it ${rabbit} rabbitmqctl cluster_status"
}

function infect_turn_all_services_debug_on () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide a project name"
        return 1
    fi
    project=$1
    controller=$(head -1 osp13-infect/controllers)
    base=$(ssh -q ${controller} "sudo -i grep -ri /etc/nova -e 'default_log_level' --exclude=*.backup")
    modified=$(echo $base | sed 's@/etc/nova/nova.conf:#@@g' | sed "s/${project}=WARN/${project}=DEBUG/g")
    filestopatch=$(infect_list_conf_files)
    for control in $(cat /home/stack/osp13-infect/controllers)
    do
        for project in $(echo ${filestopatch})
        do
            echo "turn on ${control} => ${project}"
            echo $modified
            ssh -q ${control} "echo '${modified}' | sudo -i tee -a ${project}"
        done
    done
}

function infect_conf_backup () {
    filestopatch=$(infect_list_conf_files)
    for control in $(cat /home/stack/osp13-infect/controllers)
    do
        for project in $(echo ${filestopatch})
        do
            echo "backup on ${control} => ${project}"
            ssh -q ${control} "sudo -i cp --preserve ${project} ${project}.backup"
            namedir=$(dirname ${project})
            ssh -q ${control} "sudo -i ls -la ${namedir}"
        done
    done
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
    ssh ${name} "sudo -i grep -ri /etc/${project} -e 'default_log_level'"
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
    ssh ${name} "sudo -i grep -ri /etc/${project} -e 'oslo'"
}

function infect_ssh () {
    if [ $# -lt 2 ] 
    then
        echo "Please provide a controller name and a command to play"
        return 1
    fi
    controller=$1
    cmd=$2
    echo "Playing ${cmd} on ${controller}"
    ssh -q -t ${controller} "sudo -i ${cmd}"
}

function infect_find_logs () {
    if [ $# -lt 1 ] 
    then
        echo "Please provide a controller name and a message to find"
        return 1
    fi
    controller=$1
    msg=$2
    ssh -q -t ${controller} "sudo -i grep -ri /var/log/containers -e \"${msg}\""
}

function infect_list_containers () {
    docker ps --format "{{.Names}}"
}

function infect_find_containers () {
    if [ $# -lt 2 ] 
    then
        echo "Please provide a controller name and container name"
        return 1
    fi
    controller=$1
    container=$2
    if [ $# -eq 3 ] 
    then
        ssh -q -t ${controller} "sudo -i docker ps | grep -E \"${container}\""
    else
        ssh -q -t ${controller} "sudo -i docker ps --format '{{.Names}}' | grep -E \"${container}\""
    fi
}

function infect_restart_containers () {
    if [ $# -lt 2 ] 
    then
        echo "Please provide a controller name and a container name"
        return 1
    fi
    controller=$1
    containers=$2
    for container in $(infect_find_containers "${controller}" "${containers}")
    do
        cont=$(echo ${container} | sed "s@\n@@g")
        ssh -q -t ${controller} "sudo -i docker restart ${cont}"
    done
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

function infect_install_pip_on_container () {
    if [ $# -lt 1 ] 
    then
        echo "Please provide container name"
        return 1
    fi
    container=$1
    docker exec --user root -it ${container} 'echo -e "scopev4 ::ffff:169.254.0.0/112  2\nscopev4 ::ffff:127.0.0.0/104    2\nscopev4 ::ffff:0.0.0.0/96       14\nprecedence ::ffff:0:0/96 100" > /etc/gai.conf'
    docker exec --user root -it ${container} 'curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py'
    docker exec --user root -it ${container} 'python /tmp/get-pip.py'
}

function infect_pip_install_on_container () {
    if [ $# -lt 2 ] 
    then
        echo "Please provide container name and a module to install with pip"
        return 1
    fi
    container=$1
    module=$2
    docker exec --user root -it ${container} "pip install ${$module}"
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
