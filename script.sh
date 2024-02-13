#!/bin/bash -x
set -m

yum install -y git nginx createrepo
yum module install -y go-toolset
yum group install -y "RPM Development Tools"
rpmdev-setuptree
git clone --branch=RPM https://github.com/Rolllz/teaching/ && cd teaching
mkdir my_app-1.0 && mv {"config.json","go.mod","main.go","my_app.service","my_app.spec"} my_app-1.0/
tar -c ./my_app-1.0/ -zvf my_app-1.0.tar.gz
cp my_app-1.0/my_app.spec ~/rpmbuild/SPECS/
mv my_app-1.0.tar.gz ~/rpmbuild/SOURCES/
rpmbuild -ba ~/rpmbuild/SPECS/my_app.spec
#rpm -i ~/rpmbuild/RPMS/x86_64/my_app-1.0-1.el8.x86_64.rpm
#systemctl start my_app.service
#curl -L http://localhost:8081
mkdir /usr/share/nginx/html/repo
cp ~/rpmbuild/RPMS/x86_64/my_app-1.0-1.el8.x86_64.rpm /usr/share/nginx/html/repo/
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
createrepo /usr/share/nginx/html/repo
sed -i "s/location \/ {/location \/ { root \/usr\/share\/nginx\/html;index index.html index.htm;autoindex on;/g" /etc/nginx/nginx.conf
systemctl restart nginx
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
yum repolist enabled | grep otus
yum list | grep otus
yum install my_app -y
systemctl start my_app.service
curl -L http://localhost:8081
