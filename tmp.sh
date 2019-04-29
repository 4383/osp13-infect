# store temporarly some commands before create an infect command

for el in $(infect_who_use_oslo messaging); do name=$(echo $el | awk -F "_" '{print $1}'); echo -e "patch ${name}\n"; docker exec -it --user root ${el} cp /var/log/${name}/impl_rabbit.py /usr/lib/python2.7/site-packages/oslo_messaging/_drivers; docker restart ${el}; done

