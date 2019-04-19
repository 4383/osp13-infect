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
