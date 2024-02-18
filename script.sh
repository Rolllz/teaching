#!/bin/bash -x
set -m

apt install -y apache2 wget rsyslog spawn-fcgi php php-cgi php-cli
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.timer -O /lib/systemd/system/watchlog.timer
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.sh -O /opt/watchlog.sh
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.log -O /var/log/watchlog.log
chmod +x /opt/watchlog.sh
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.service -O /lib/systemd/system/watchlog.service
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog -O /etc/default/watchlog
systemctl start watchlog.service && systemctl start watchlog.timer
cat /var/log/syslog | grep Master
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/spawn-fcgi.service -O /lib/systemd/system/spawn-fcgi.service
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/spawn-fcgi -O /etc/default/spawn-fcgi
systemctl start spawn-fcgi && systemctl status spawn-fcgi
chmod +x /usr/share//doc/apache2/examples/setup-instance
for i in {1,2}; do
/usr/share/doc/apache2/examples/setup-instance $i
wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/$i-ports.conf -O /etc/apache2-$i/ports.conf
systemctl start apache2@$i && systemctl status apache2@$i
done
