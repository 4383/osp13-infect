function infect_list_containers () {
    docker ps --format "{{.Names}}"
}

function infect_who_use_oslo () {
    if [ $# -eq 0 ] 
    then
        echo "Please provide oslo project name"
        return 1
    fi
    name=$1
    for container in $(list_containers)
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
    for container in $(list_containers)
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
