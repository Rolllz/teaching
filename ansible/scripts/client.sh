#!/bin/bash -x

PASSWD="12345678"
yes "yes" | ipa-client-install --mkhomedir --domain=OTUS.LAN --server=ipa.otus.lan --no-ntp -p admin -w $PASSWD --realm OTUS.LAN
yes $PASSWD | kinit otus-user