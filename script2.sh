#!/bin/bash -x
set -m

mkdir /usr/lib/dracut/modules.d/01test
wget https://gist.githubusercontent.com/lalbrekht/ac45d7a6c6856baea348e64fac43faf0/raw/69598efd5c603df310097b52019dc979e2cb342d/gistfile1.txt -O /usr/lib/dracut/modules.d/01test/test.sh
wget https://gist.githubusercontent.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85/raw/80060b7b300e193c187bbcda4d8fdf0e1c066af9/gistfile1.txt -O /usr/lib/dracut/modules.d/01test/module-setup.sh
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
sed -i "s/rhgb quiet//g" /boot/grub2/grub.cfg