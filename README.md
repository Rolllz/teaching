Занятие 1. Vagrant-стенд для обновления ядра и создания образа системы

Цель домашнего задания
Научиться обновлять ядро в ОС Linux. Получение навыков работы с Vagrant. 

Описание домашнего задания
1) Запустить ВМ с помощью Vagrant.
2) Обновить ядро ОС из репозитория ELRepo.
3) Оформить отчет в README-файле в GitHub-репозитории.

В данном ДЗ был использован Debian 12. После установки и запуска ОС выполняются следующие команды:

#обновление репозиториев

sudo apt-get update

#установка необходимых для компиляции ядра пакетов

sudo apt-get install -y gcc cmake ncurses-dev libssl-dev bc flex libelf-dev bison git fakeroot build-essential xz-utils lsb-release software-properties-common apt-transport-https ca-certificates curl dwarves

#переходим в shared folder

cd /mnt/vagrant

#качаем туда архив с исходниками, на месте распаковываем и переходим в директорию с ними

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.7.tar.xz

tar xvf linux-6.7.tar.xz

cd linux-6.7

#копируем текущий конфиг ядра в папку с исходниками

cp -v /boot/config-$(uname -r) .config

#выполняем make menuconfig для этого конфига, чтобы он был заточен под текущие настройки

yes "" | make oldconfig

#выполняем сборку

make -j$(($(nproc)+1))

sudo make modules_install

sudo make install

#обновляем версию ядра, а также GRUB

sudo update-initramfs -c -k 6.7.0

sudo update-grub

#устанавливаем загрузку по умолчанию нового ядра

sudo grep gnulinux /boot/grub/grub.conf | grep "6.7.0' --class" > /tmp/version_of_kernel.txt

sudo su

export VE=$(awk -F"'" '{print 4}' <<< cat /tmp/version_of_kernel.txt)

echo "DEFAULT_GRUB=$VE" >> /etc/default/grub

exit

#перезагружаемся и восстанавливаем Virtualbox Shared Folder

sudo shutdown -r now

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1MNt-MkbD-am9jkY8WXoT7JbL0XXxHAWc' -O /tmp/VboxGuestAdditions.iso

sudo mkdir /mnt/iso

sudo mount -o loop /tmp/VboxGuestAdditions.iso /mnt/iso

cd /mnt/iso

sudo ./autorun.sh

sudo mount -t vboxfs mnt_vagrant /mnt/vagrant

#на всякий случай очищаем пакетный менеджер от лишних пакетов

sudo autoremove -y

#выводим на экран текущую версию ядра

uname -r
