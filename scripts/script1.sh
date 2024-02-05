#!/bin/bash -x
set -m

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
echo "Устанавливаем пакетики ..."
yum install -y -q mdadm smartmontools hdparm gdisk device-mapper lvm2 xfsdump
#yes "vagrant" | passwd root
echo "Создаем временный раздел под / ..."
vgcreate vg_root /dev/sdb && lvcreate -n lv_root -l +100%FREE /dev/vg_root
mkfs.xfs /dev/vg_root/lv_root && mount /dev/vg_root/lv_root /mnt
echo "Создаем дампик папочки, восстанавливаем его в другую папочку и монтируем всё в нее ..."
xfsdump -v silent -J - /dev/VolGroup00/LogVol00 | xfsrestore -v silent -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
cp -r /vagrant/scripts /mnt
echo "Делаем chroot ..."
chroot /mnt/ /bin/bash /scripts/script2.sh