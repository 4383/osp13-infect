controllers_file = "/tmp/controllers"
data = []
controllers =  open(controllers_file, "r")
for controller in controllers.readlines():
    line = controller.replace(" ", "").replace("\n", "")
    infos = line.split("|")
    name = infos[2]
    ip = infos[6].replace("ctlplane=", "")
    data.append("{name} ansible_host={ip} ansible_user=heat-admin".format(
        name=name, ip=ip))
controllers.close()
controllers =  open("/home/stack/tmp/ansible-host-out".format(controllers_file), "w+")
controllers.write("[controllers]\n")
for el in data:
    controllers.write("{}\n".format(el))
controllers.close()
