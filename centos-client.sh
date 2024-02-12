#!/bin/bash -x
set -m

yum install -y nfs-utils -y
systemctl enable firewalld.service --now
systemctl status firewalld.service
echo "192.168.56.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
systemctl daemon-reload
systemctl restart remote-fs.target
ls -al /mnt
mount | grep mnt
ls -al /mnt/upload/
touch /mnt/upload/client_file