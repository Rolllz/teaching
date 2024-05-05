#!/bin/bash

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sdb
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
    # all space
  p # print the in-memory partition table
  w # write the partition table
EOF
mkfs.ext4 /dev/sdb1
#mkdir /iso
mount /dev/sdb1 /mnt