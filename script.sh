#!/bin/bash -x
set -m

apt install -y apache2 wget rsyslog spawn-fcgi php php-cgi php-cli
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.timer -O /lib/systemd/system/watchlog.timer
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.sh -O /opt/watchlog.sh
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.sh -O /var/log/watchlog.log
chmod +x /opt/watchlog.sh
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.service -O /lib/systemd/system/watchlog.service
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog -O /etc/default/watchlog
systemctl start watchlog.timer
cat /var/log/syslog | grep Master
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/spawn-fcgi.service -O /lib/systemd/system/spawn-fcgi.service
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/spawn-fcgi -O /etc/default/spawn-fcgi
systemctl start spawn-fcgi && systemctl status spawn-fcgi
chmod +x /usr/share//doc/apache2/examples/setup-instance
/usr/share/doc/apache2/examples/setup-instance 1
/usr/share/doc/apache2/examples/setup-instance 2
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/apache2-1_ports.conf -O /etc/apache2-1/ports.conf
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/apache2-2_ports.conf -O /etc/apache2-2/ports.conf
systemctl start apache2@1 && systemctl status apache2@1
systemctl start apache2@2 && systemctl status apache2@2
