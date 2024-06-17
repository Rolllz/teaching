#!/bin/bash -x

PASSWD="12345678"
ipa-server-install -r OTUS.LAN -a $PASSWD --unattended -p $PASSWD -N --mkhomedir
yes $PASSWD | kinit admin
yes $PASSWD | ipa user-add otus-user --first=Otus --last=User --password
