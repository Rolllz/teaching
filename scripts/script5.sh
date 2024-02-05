#!/bin/bash -x
set -m

echo "Удаляем временный логический раздел под / ..."
lvremove -y /dev/vg_root/lv_root && vgremove /dev/vg_root && pvremove /dev/sdb
echo "Создаем новый логический раздел под домашнюю папку..."
lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol_Home
echo "Монтируем этот раздел в /mnt, копируем все из старой домашней папки и затираем ее..."
mount /dev/VolGroup00/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
echo "Размонтируем /mnt и монтируем новый раздел в /home ..."
umount /mnt
mount /dev/VolGroup00/LogVol_Home /home/
echo "Обновляем fstab ..."
echo "$(blkid | grep Home | awk '{print $2}') /home xfs defaults 0 0" >> /etc/fstab
echo "Теперь снапшоты. Создаем 20 файлов в домашней папке ..."
touch /home/file{1..20}
echo "Создаем снапшот домашней папки"
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
echo "Удаляем некоторые из только что созданных файлов ..."
rm -f /home/file{11..20}
echo "Размонтируем /home, восстанваливаем удаленные файлы из снапшота и монтируем /home обратно ..."
umount /home
lvconvert --merge /dev/VolGroup00/home_snap
mount /home