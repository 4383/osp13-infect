controllers_file = "/tmp/controllers"
all_controllers = []
data_ssh_hosts = []
data_ansible_hosts = []
controllers =  open(controllers_file, "r")
for controller in controllers.readlines():
    line = controller.replace(" ", "").replace("\n", "")
    infos = line.split("|")
    name = infos[2]
    ip = infos[6].replace("ctlplane=", "")
    ## ansible
    data_ansible_hosts.append("{name} ansible_host={ip} ansible_user=heat-admin".format(
        name=name, ip=ip))
    ## ssh
    data_ssh_hosts.append("Host {name}\n\tUser heat-admin\n\tHostname {ip}\n\n".format(
        name=name, ip=ip))
    all_controllers.append(name)
controllers.close()

#####
controllers =  open("/home/stack/tmp/ansible-host-out".format(controllers_file), "w+")
controllers.write("[controllers]\n")
for el in data_ansible_hosts:
    controllers.write("{}\n".format(el))
controllers.close()

with open("/home/stack/.ssh/config", "a+") as conf:
    for el in data_ssh_hosts:
        conf.write(el)

with open("/home/stack/osp13-infect/controllers", "w+") as controllers:
    controllers.write("\n".join(all_controllers))
