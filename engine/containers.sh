function infect_list_containers () {
    docker ps --format "{{.Names}}"
}

function infect_configure_containers_repos () {
    for container in $(infect_list_containers)
    do
        current=$(pwd)
        cd /etc/
        tar Ccf yum.repos.d/ | docker exec -i foo tar Cxf /etc/yum.repos.d/ -
        cd $current
        docker exec -it ${container} test -d /usr/lib/python2.7/site-packages/oslo_${name} && echo ${container}
    done
}

function infect_install_base_apps_on_containers () {
    for container in $(infect_list_containers)
    do
        docker exec -it ${container} yum install -y git
    done
}

function infect_install_base_apps_on_containers () {
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
