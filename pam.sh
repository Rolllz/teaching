#!/bin/bash -x
set -m

sed -i 's/#PasswordAuthentication.*$/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd.service
apt update && apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
useradd otusadm && useradd otus
for i in {otus,otusadm}; do
    mkdir /home/$i
    cp -rT /etc/skel /home/$i
    chown -R $i:$i /home/$i
done
groupadd -f admin && groupadd -f dockerallow
yes "Otus2024!" | passwd otusadm && yes "Otus2024!" | passwd otus && yes "vagrant" | passwd root
for i in {vagrant,root,otusadm}; do usermod -aG admin $i; done
cp -f /vagrant/login.sh /usr/local/bin/
echo "auth required pam_exec.so debug /usr/local/bin/login.sh" > /etc/pam.d/sshd
echo "%dockerallow ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers
cp /etc/sudoers /etc/sudoers.bak
cp /etc/profile /etc/profile.bak
sed -i "s/sudo\tALL=(ALL:ALL) ALL/sudo\tALL=(ALL:ALL) NOPASSWD: ALL/g"
echo $PATH > /tmp/path.txt
for i in {docker,sudo,dockerallow}; do usermod -aG $i otus; done
#systemctl daemon-reload
