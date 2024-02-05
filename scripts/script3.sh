#!/bin/bash -x
set -m

echo "Меняем размер старого логического раздела ..."
yes "y" | lvremove /dev/VolGroup00/LogVol00
yes "y" | lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
echo "Создаем файловую систему на нем и копируем все обратно ..."
mkfs.xfs /dev/VolGroup00/LogVol00
xfsdump -v silent -J - /dev/vg_root/lv_root | xfsrestore -v silent -J - /mnt
echo "Монтируем все обратно ..."
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
mv /scripts /mnt/scripts
echo "Делаем chroot ..."
chroot /mnt/ /bin/bash /scripts/script4.sh