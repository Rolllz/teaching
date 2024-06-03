#!/bin/bash

set -mx

cd /etc/openvpn || exit
yes "" | ssh-keygen -N ""
sshpass -p "vagrant" ssh-copy-id -o stricthostkeychecking=no root@192.168.56.20
/usr/share/easy-rsa/easyrsa init-pki
EASYRSA_BATCH='1'
echo 'rasvpn' | /usr/share/easy-rsa/easyrsa build-ca nopass
echo 'rasvpn' | /usr/share/easy-rsa/easyrsa gen-req server nopass
echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req server server
/usr/share/easy-rsa/easyrsa gen-dh
openvpn --genkey secret ca.key
echo 'client' | /usr/share/easy-rsa/easyrsa gen-req client nopass
echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req client client
scp ./pki/ca.crt root@192.168.56.20:/etc/openvpn/ca.crt
scp ./pki/issued/client.crt root@192.168.56.20:/etc/openvpn/client.crt
scp ./pki/private/client.key root@192.168.56.20:/etc/openvpn/client.key
echo 'iroute 10.10.10.0 255.255.255.0' > /etc/openvpn/client/client