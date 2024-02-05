#!/bin/bash -x
set -m

echo "Конфигурируем граб ..."
grub2-mkconfig -o /boot/grub2/grub.cfg
echo "Генерируем образы ..."
cd /boot
for i in $(ls initramfs-*img); do ii=${i#initramfs-}; ii=${ii%.img}; dracut $i $ii --force; done
echo "Подменяем строчку в конфиге ..."
sed -i "s/VolGroup00/vg_root/g" /boot/grub2/grub.cfg
sed -i "s/LogVol00/lv_root/g" /boot/grub2/grub.cfg