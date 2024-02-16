Домашнее задание

    Работа с загрузчиком

Цель:

    - научиться попадать в систему без пароля;
    - устанавливать систему с LVM и переименовывать в VG;
    - добавлять модуль в initrd;

Что нужно сделать?

    1. Попасть в систему без пароля несколькими способами.
    2. Установить систему с LVM, после чего переименовать VG.
    3. Добавить модуль в initrd.

Для системы, которая должна здесь использоваться, не работает ни один способ смены пароля. В шелл попасть можно последними двумя, так как первый способ для Debian-based систем, и то необходимо из параметров удалить все, что связано с консолью.

Однако после смены пароля и перезагрузки пароль меняется на какой-то другой, и выполнить вход невозможно ни под одним пользователем.

В Debian и Ubuntu всё работает отлично.

В названии скрипта на установку модуля должен быть дефис, а не нижнее подчеркивание. Только в этом случае система увидит файл и установит модуль.

В данной работе была использована ОС Centos 7.

После запуска ОС выполняются следующие команды:

Переименование VolGroup00:

    vgrename VolGroup00 OtusRoot

Установка wget для скачивания файлов конфигурации:

    yum install -y wget

Скачиваем и сразу заменяем файлы:

    wget https://gist.githubusercontent.com/lalbrekht/ef78c39c236ae223acfb3b5e1970001c/raw/3bdf1d1a374eff4a5696dcea226ae5c4ca4d6374/gistfile1.txt -O /etc/default/grub
    wget https://gist.githubusercontent.com/lalbrekht/1a9cae3cb64ce2dc7bd301e48090bd56/raw/aa1cf0b3fd794d454dfa7fc2770784ef29ae89ea/gistfile1.txt -O /boot/grub2/grub.cfg
    wget https://gist.githubusercontent.com/lalbrekht/cdf6d745d048009dbe619d9920901bf9/raw/f9ae66d2d2fc727791d5ea69d67cc5760c4c5fea/gistfile1.txt -O /etc/fstab
    
Генерируем новый образ:

    mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

Далее работает триггер на перезагрузку, машину загружается с новым ядром.

Создаем папку для тестового скрипта внутри dracut и скачиваем туда файлы:
    
    mkdir /usr/lib/dracut/modules.d/01test
    wget https://gist.githubusercontent.com/lalbrekht/ac45d7a6c6856baea348e64fac43faf0/raw/69598efd5c603df310097b52019dc979e2cb342d/gistfile1.txt -O /usr/lib/dracut/modules.d/01test/test.sh
    wget https://gist.githubusercontent.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85/raw/80060b7b300e193c187bbcda4d8fdf0e1c066af9/gistfile1.txt -O /usr/lib/dracut/modules.d/01test/module-setup.sh

Еще раз генерируем образ:

    mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

Проверяем наличие нового модуля в загрузчике:

    lsinitrd -m /boot/initramfs-$(uname -r).img | grep test

Удаляем из конфига тихую загрузку:
    
    sed -i "s/rhgb quiet//g" /boot/grub2/grub.cfg

Далее еще один триггер на перезагрузку, и в GUI можно будет увидеть пингвинчика :)
