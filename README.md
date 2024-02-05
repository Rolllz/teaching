Занятие 5. Файловые системы и LVM.

Цель домашнего задания
создавать и работать с логическими томами

Описание домашнего задания
- на имеющемся образе (centos/7 1804.2)
https://gitlab.com/otus_linux/stands-03-lvm

/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

уменьшить том под / до 8G
выделить том под /home
выделить том под /var (/var - сделать в mirror)
для /home - сделать том для снэпшотов
прописать монтирование в fstab (попробовать с разными опциями и разными файловыми системами на выбор)

Работа со снапшотами:
сгенерировать файлы в /home/
снять снэпшот
удалить часть файлов
восстановиться со снэпшота

В данном ДЗ был использован Debian 12.
Для работы Vagrant необходимы плагины vagrant, virtualbox, vagrant-reload, vagrant-disksize.
После установки и запуска ОС выполняются следующие команды:

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

Команды в файле script2.sh следующие:

echo "Конфигурируем граб ..."
grub2-mkconfig -o /boot/grub2/grub.cfg
echo "Генерируем образы ..."
cd /boot
for i in $(ls initramfs-*img); do ii=${i#initramfs-}; ii=${ii%.img}; dracut $i $ii --force; done
echo "Подменяем строчку в конфиге ..."
sed -i "s/VolGroup00/vg_root/g" /boot/grub2/grub.cfg
sed -i "s/LogVol00/lv_root/g" /boot/grub2/grub.cfg

Далее машина перезагружается, и выполняются следующте команды:

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

Команды в файле script4.sh следующие:

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

Далее ещё одна перезагрузка, после чего выполняется последняя часть:

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
