#!/bin/bash

sudo mdadm --zero-superblock --force /dev/sd{b..g}
yes "y" | sudo mdadm --create --verbose /dev/md0 -l 10 -n 4 /dev/sd{b..e}
yes "y" | sudo mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd[fg]
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
sudo mdadm /dev/md0 --fail /dev/sde
sudo mdadm /dev/md0 --remove /dev/sde
sudo mdadm /dev/md0 --add /dev/sde
sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do
    sudo mkfs.ext4 /dev/md0p$i
    sudo mkdir -p /raid/part$i
    sudo mount /dev/md0p$i /raid/part$i
    sudo chmod 777 /etc/fstab
    echo "/dev/md126p$i /raid/part$i ext4 uid=0,gid=0 0 2" >> /etc/fstab
    sudo chmod 644 /etc/fstab
done
sudo dd if=/dev/sda of=/dev/md1 bs=100M status=progress
sudo update-grub
