yum install -y vim gdb
tar cfvz controller-payload.tar.gz payload

CONTROLLERS=$(nova list | grep "controller" | awk '{print $12}' | awk -F "=" '{print $2}')
for controller in ${CONTROLLERS}
do
	scp controller-payload.tar.gz heat-admin@${controller}:~
	ssh heat-admin@${controller} tar xfve controller-payload.tar.gz
	ssh heat-admin@${controller} sudo -i -c /home/heat-admin/payload/infect.sh
done
