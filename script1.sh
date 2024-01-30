#!/bin/bash

lsblk > /vagrant/file1.txt
sudo apt update
sudo apt install -y mdadm smartmontools hdparm gdisk lshw parted
sudo modprobe {raid{0,1,5,6,10},linear,multipath}
sudo chmod 777 /etc/mdadm/mdadm.conf
