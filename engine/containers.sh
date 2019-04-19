function list_containers () {
    docker ps --format "{{.Names}}"
}

function find_oslo () {
    if [ $# -eq 0 ] 
    then
        name=$1
    else
        echo "Please provide oslo project name"
    fi
    for container in $(list_containers)
    do
        docker exec -it ${container} test -d /usr/lib/python2.7/site-packages/oslo_${name} && echo ${container}
    done
}
