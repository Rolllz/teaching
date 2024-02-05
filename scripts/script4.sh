#!/bin/bash -x
set -m

echo "Конфигурируем граб ..."
grub2-mkconfig -o /boot/grub2/grub.cfg
echo "Генерируем образы ядер заново ..."
cd /boot
for i in $(ls initramfs-*img); do ii=${i#initramfs-}; ii=${ii%.img}; dracut $i $ii --force; done
echo "Создаем логический раздел под /var ..."
vgcreate vg_var /dev/sdc /dev/sdd
lvcreate -L 950M -m1 -n lv_var vg_var
echo "Создаем файловую систему и копируем все из старой /var ..."
mkfs.ext4 /dev/vg_var/lv_var
cp -aR /var/* /mnt/
mkdir /tmp/oldvar && mv /var/* /tmp/oldvar
echo "Размонтируем chroot ..."
umount /mnt
echo "Монтируем новую папку под /var ..."
mount /dev/vg_var/lv_var /var
echo "Обновляем fstab ..."
echo "$(blkid | grep var: | awk '{print $2}') /var ext4 defaults 0 0" >> /etc/fstab