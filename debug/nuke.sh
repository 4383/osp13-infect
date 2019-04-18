PATCH=impl_rabbit.py
OSLO_PATH=/usr/lib/python2.7/site-packages/oslo_messaging
OSLO_DRIVERS_PATH=$OSLO_PATH/_drivers
for container in $(docker ps --filter "name=nova*" --format "{{.Names}}"); 
do
	echo "============"
	echo ${container}
	echo "------------"
	NEED_TO_UPDATE=$(docker exec -it ${container} test -d ${OSLO_DRIVERS_PATH} && echo "ok")
	if [ "${NEED_TO_UPDATE}" != "ok" ]; then
		echo "not need to update... continue"
	fi
	echo "Copying python file to ${container}:${OSLO_DRIVERS_PATH}/${PATCH}"
	docker cp ${PATCH} ${container}:${OSLO_DRIVERS_PATH}/${PATCH}
	sleep 3
	echo "Restart ${container}"
	docker restart ${container}
	echo "============"
done

