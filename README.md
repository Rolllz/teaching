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


#установка и обновление необходимых для компиляции ядра пакетов

sudo apt-get install -y gcc cmake ncurses-dev libssl-dev bc flex libelf-dev bison git fakeroot build-essential xz-utils lsb-release software-properties-common apt-transport-https ca-certificates curl dwarves dkms


#качаем архив с исходниками и VirtualboxGuestAdditions, на месте распаковываем архив и переходим в директорию с ними

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1MNt-MkbD-am9jkY8WXoT7JbL0XXxHAWc' -O ./VboxGuestAdditions.iso

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.7.tar.xz

tar xvf linux-6.7.tar.xz

cd linux-6.7


#копируем текущий конфиг ядра в папку с исходниками

cp -v /boot/config-$(uname -r) .config


#выполняем make menuconfig для этого конфига, чтобы он был заточен под текущие настройки

yes "" | make oldconfig


#выполняем сборку

make -j$(($(nproc)+1)) -s

sudo make modules_install -s

sudo make install


#обновляем версию ядра, а также GRUB

sudo update-initramfs -c -k 6.7.0

sudo update-grub

Предыдущее действие не обязательно, так как команда make install сама сгенерирует образ ядра и файл vmlinuz и положит их в директорию /boot


#устанавливаем загрузку по умолчанию нового ядра

sudo grep gnulinux /boot/grub/grub.conf | grep "6.7.0' --class" | awk -F"'" '{print $4}' > ./version_of_kernel.txt

sudo echo "DEFAULT_GRUB=$(cat ./version_of_kernel.txt)" >> /etc/default/grub

#Данное действие необходимо в случае, если другие версии ядра уже не нужны. В дополнение можно удалить все предыдущие версии командой sudo rm /boot/vmlinuz* /boot/initrd* перед компиляцией ядра, тогда загрузку по умолчанию можно не выполнять

#удаляем архив и директорисю с исходниками

sudo rm -r ./linux-6.7

rm linux-6.7.tar.xz


#перезагружаемся и восстанавливаем Virtualbox Shared Folder

sudo shutdown -r now

sudo mkdir /mnt/iso

sudo mount -o loop ./VboxGuestAdditions.iso /mnt/iso

cd /mnt/iso

sudo ./autorun.sh

sudo mount -t vboxfs mnt_vagrant /mnt/vagrant


#на всякий случай очищаем пакетный менеджер от лишних пакетов

sudo apt autoremove -y

#выводим на экран текущую версию ядра

uname -r
