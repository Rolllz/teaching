#!/bin/bash -x
set -m

yum install nfs-utils -y
systemctl enable firewalld.service --now
firewall-cmd --add-service={"nfs3","rpc-bind","mountd"} --permanent && firewall-cmd --reload
systemctl enable nfs --now
ss -tnplu | grep 2049
ss -tnplu | grep 111
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod -R 0777 /srv/share
echo "/srv/share 192.168.56.11/32(rw,sync,root_squash)" > /etc/exports
exportfs -var
exportfs -s
cd /srv/share/upload
touch check_file