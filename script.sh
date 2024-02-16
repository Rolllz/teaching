#!/bin/bash -x
set -m

vgrename VolGroup00 OtusRoot
yum install wget -y
wget https://gist.githubusercontent.com/lalbrekht/ef78c39c236ae223acfb3b5e1970001c/raw/3bdf1d1a374eff4a5696dcea226ae5c4ca4d6374/gistfile1.txt -O /etc/default/grub
wget https://gist.githubusercontent.com/lalbrekht/1a9cae3cb64ce2dc7bd301e48090bd56/raw/aa1cf0b3fd794d454dfa7fc2770784ef29ae89ea/gistfile1.txt -O /boot/grub2/grub.cfg
wget https://gist.githubusercontent.com/lalbrekht/cdf6d745d048009dbe619d9920901bf9/raw/f9ae66d2d2fc727791d5ea69d67cc5760c4c5fea/gistfile1.txt -O /etc/fstab
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
