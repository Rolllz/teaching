Занятие 5. Дисковая подсистема. Работа с mdadm.

Цель домашнего задания
Научиться использовать утилиту для управления программными RAID-массивами в Linux

Описание домашнего задания
- добавить в Vagrantfile еще дисков;
- сломать/починить raid;
- собрать R0/R5/R10 на выбор;
- прописать собранный рейд в конф, чтобы рейд собирался при загрузке;
- создать GPT раздел и 5 партиций.

Доп. задание*
Vagrantfile, который сразу собирает систему с подключенным рейдом и смонтированными разделами. После перезагрузки стенда разделы должны автоматически примонтироваться.

Задание повышенной сложности**
Перенести работающую систему с одним диском на RAID 1. Даунтайм на загрузку с нового диска предполагается.

В данном ДЗ был использован Debian 12.
Для работы Vagrant необходимы плагины vagrant, virtualbox, vagrant-reload, vagrant-disksize.
После установки и запуска ОС выполняются следующие команды:

lsblk > /vagrant/file1.txt

sudo apt update #обновляем и устанавливаем необходимые для работы пакеты

sudo apt install -y mdadm smartmontools hdparm gdisk lshw parted

sudo modprobe {raid{0,1,5,6,10},linear,multipath} #подгружаем модули работы с raid-массивами

На этом выполнение первого скрипта заканчивается, и запускается триггер перезагрузки
После перезагрузки выполняется второй скрипт:

#Зачищаем суперблоки на дисках
sudo mdadm --zero-superblock --force /dev/sd{b..g}

#создаем два массива: один - для тестирования, второй - для переноса системы
yes "y" | sudo mdadm --create --verbose /dev/md0 -l 10 -n 4 /dev/sd{b..e}
yes "y" | sudo mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd[fg]

#Записываем данные массивов в конфиг
sudo chmod 777 /etc/mdadm/mdadm.conf
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
sudo chmod 644 /etc/mdadm/mdadm.conf

#ломаем и восстанавливаем один из дисков
sudo mdadm /dev/md0 --fail /dev/sde
sudo mdadm /dev/md0 --remove /dev/sde
sudo mdadm /dev/md0 --add /dev/sde

#Создаем таблицу разделов
sudo parted -s /dev/md0 mklabel gpt

#Создаем разделы
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%

#Создаем папки, монитруем в них разделы и обновляем fstab
for i in $(seq 1 5); do
    sudo mkfs.ext4 /dev/md0p$i
    sudo mkdir -p /raid/part$i
    sudo mount /dev/md0p$i /raid/part$i
    sudo chmod 777 /etc/fstab
    echo "/dev/md126p$i /raid/part$i ext4 uid=0,gid=0 0 2" >> /etc/fstab
    sudo chmod 644 /etc/fstab
done

#Копируем систему на raid 1 и обновляем grub
sudo dd if=/dev/sda of=/dev/md1 bs=100M status=progress
sudo update-grub

Далее запускается еще один триггер на перезагрузку и выполняется последняя команда:

lsblk > /vagrant/file2.txt
