pcs status
docker exec -it nova_scheduler /bin/bash
for el in $(sudo docker ps | grep nova | awk '{print $1}'); do docker exec -it $el "grep 'Unexpected error during heartbeart thread processing' /var/log/nova/"; done
for el in $(sudo docker ps | grep nova | awk '{print $1}'); do docker exec -it $el "grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'"; done
for el in $(sudo docker ps | grep nova | awk '{print $1}'); do docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
fg
for el in $(sudo docker ps | grep nova | awk '{print $1}'); do docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
for el in $(sudo docker ps | grep nova | awk '{print $1}'); do echo $el; done
for el in $(sudo docker ps | grep nova | awk '{print $10}'); do echo $el; done
for el in $(sudo docker ps | grep nova | awk '{print $13}'); do echo $el; done
for el in $(sudo docker ps | grep nova | awk '{print $12}'); do echo $el; done
for el in $(sudo docker ps | grep nova | awk '{print $12}'); do echo $el; docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
fg
for el in $(sudo docker ps | grep nova | awk '{print $12}'); do echo "============";echo $el;echo "============"; docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
docker exec -it nova_scheduler /bin/bash
for el in $(sudo docker ps | grep nova | awk '{print $12}'); do echo "============";echo $el;echo "============"; docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
pcs status
for el in $(sudo docker ps | grep nova | awk '{print $12}'); do echo "============";echo $el;echo "============"; docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
docker ps | grep nova
for el in $(sudo docker ps | grep nova | awk '{print $12}'); do echo "============";echo $el;echo "============"; done
for el in $(docker ps | grep nova | awk '{print $12}'); do echo "============";echo $el;echo "============"; done
echo $?
for el in $(docker ps | grep nova | awk '{print $12}'); do echo "============";echo $el;echo "============"; done
docker ps | grep nova | awk '{print $12}'
docker ps | grep nova | awk '{print $1}'
for el in $(docker ps | grep nova | awk '{print $1}'); do echo "============";echo $el;echo "============"; done
for el in $(docker ps | grep nova | awk '{print $1}'); do echo "============";echo $el;echo "============"; docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
docker exec -it nova_scheduler grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'
docker exec -it nova_scheduler grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing' | more
docker exec -it nova_scheduler grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing' 
docker exec -it nova_api
docker ps | grep nova
docker exec -it nova_api /bin/bash
docker restart nova_api 
docker ps | grep nova
docker exec -it nova_api /bin/bash
docker cp nova_api:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/_impl_rabbit.py .
docker exec -it nova_api /bin/bash
docker cp nova_api:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/impl_rabbit.py .
vim impl_rabbit.py 
for el in $(docker ps | grep nova | awk '{print $1}'); do echo "============";echo $el;echo "============"; docker copy impl_rabbit.py $el:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/; docker restart $el; done
for el in $(docker ps | grep nova | awk '{print $1}'); do echo "============";echo $el;echo "============"; docker cp impl_rabbit.py $el:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/; docker restart $el; done
vim nuke.sh
sh nuke.sh 
fg
docker ps
docker ps -h
docker ps --filter "name=nova*"
docker ps --filter "name=nova*" --format "{{.Names}}"
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
ls
fg
ls
sh nuke.sh 
docker exec -it nova_metadata test -d /usr/lib/python2.7/site-packages/oslo_messaging
docker exec -it nova_metadata test -d /usr/lib/python2.7/site-packages/oslo_messaging && echo "ok"
echo $(docker exec -it nova_metadata test -d /usr/lib/python2.7/site-packages/oslo_messaging)
docker exec -it nova_metadata test -d /usr/lib/python2.7/site-packages/oslo_messaging/_drivers && echo "ok"
docker exec -it nova_api_cron test -d /usr/lib/python2.7/site-packages/oslo_messaging/_drivers && echo "ok"
docker exec -it nova_scheduler test -d /usr/lib/python2.7/site-packages/oslo_messaging/_drivers && echo "ok"
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 
fg
sh nuke.sh 

docker exec -it nova_api
docker exec -it nova_api /bin/bash
history | grep for
for el in $(docker ps | grep nova | awk '{print $1}'); do echo "============";echo $el;echo "============"; docker exec -it $el grep -ri /var/log/nova -e 'Unexpected error during heartbeart thread processing'; done
for el in $(docker ps | grep nova | awk '{print $1}'); do echo "============";echo $el;echo "============"; docker exec -it $el grep -ri /var/log/nova -e 'Herve'; done
docker exec -it nova_api /bin/bash
vim impl_rabbit.py 
sh nuke.sh 
docker exec -it nova_api /bin/bash
sh nuke.sh 
docker cp impl_rabbit.py nova_api:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/impl_rabbit.py
docker copy impl_rabbit.py nova_api:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/impl_rabbit.py
docker cp impl_rabbit.py nova_api:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/impl_rabbit.py
docker restart nova_api
docker exec -it nova_api /bin/bash
fg
vim impl_rabbit.py 
docker cp impl_rabbit.py nova_api:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/impl_rabbit.py
docker exec -it nova_api /bin/bash
docker restart nova_api
docker exec -it nova_api /bin/bash
ls /etc/yum.repos.d/
docker exec -it nova_api /bin/bash
cat /etc/yum.repos.d/redhat.repo 
docker cp /etc/yum.repos.d/* nova_api:/etc/yum.repos.d/
docker cp /etc/yum.repos.d/ nova_api:/etc/yum.repos.d/
docker cp /etc/yum.repos.d/rhos-release-* nova_api:/etc/yum.repos.d/
docker cp /etc/yum.repos.d/rhos-release-* nova_api:/etc/yum.repos.d
#docker cp /etc/yum.repos.d/rhos-release-* nova_api:/etc/yum.repos.d
ls /etc/yum.repos.d/
docker cp /etc/yum.repos.d/rhos-release-13.repo nova_api:/etc/yum.repos.d/rhos-release-13.repo
docker cp /etc/yum.repos.d/rhos-release-rhel-7.6.repo nova_api:/etc/yum.repos.d/rhos-release-rhel-7.6.repo
docker exec -it nova_api /bin/bash
docker ps --filter "name=nova*" --format "{{.Names}}"
docker cp /etc/yum.repos.d/rhos-release-rhel-7.6.repo nova_metada:/etc/yum.repos.d/rhos-release-rhel-7.6.repo
docker cp /etc/yum.repos.d/rhos-release-rhel-7.6.repo nova_metadata:/etc/yum.repos.d/rhos-release-rhel-7.6.repo
docker cp /etc/yum.repos.d/rhos-release-13.repo nova_metadata:/etc/yum.repos.d/rhos-release-13.repo
docker cp impl_rabbit.py nova_metadata:/usr/lib/python2.7/site-packages/oslo_messaging/_drivers/impl_rabbit.py
docker restart nova_metadata
docker exec -it nova_metadata /bin/bash
exit
