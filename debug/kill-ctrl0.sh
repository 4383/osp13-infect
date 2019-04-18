#!/bin/sh
ipmitool -I lanplus -H 172.16.0.1 -L ADMINISTRATOR -p 6231 -U admin -R 12 -N 5 -Ppassword power status
ipmitool -I lanplus -H 172.16.0.1 -L ADMINISTRATOR -p 6231 -U admin -R 12 -N 5 -Ppassword power off
sleep 2
ipmitool -I lanplus -H 172.16.0.1 -L ADMINISTRATOR -p 6231 -U admin -R 12 -N 5 -Ppassword power status
