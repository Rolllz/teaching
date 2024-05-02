#!/bin/bash
set -o pipefail

echo "exit" | ssh -o StrictHostKeyChecking=no borg@192.168.11.160
echo 'export BORG_PASSPHRASE="Otus1234"' >> ~/.bashrc && source ~/.bashrc
BORG_PASSPHRASE="Otus1234" borg init --encryption=repokey borg@192.168.11.160:/var/backup/
BORG_PASSPHRASE="Otus1234" borg create --stats --list borg@192.168.11.160:/var/backup/::"etc-{now:%Y-%m-%d_%H:%M:%S}" /etc
