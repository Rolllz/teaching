Домашнее задание
PAM

Цель домашнего задания
Научиться создавать пользователей и добавлять им ограничения

Описание домашнего задания:

    ```Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
    Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис*```

В данном ДЗ был использован Debian 12.
После установки и запуска ОС выполняются следующие команды:

Разрешаем доступ по ssh с помощью пароля:

    sed -i 's/#PasswordAuthentication.*$/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    systemctl restart sshd.service

Устанавливаем Docker:

    apt update && apt install ca-certificates curl -y
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

Создаем пользователей для 

for i in {otus,otusadm}; do
    useradd -s /bin/bash $i
    mkdir /home/$i
    cp -rT /etc/skel /home/$i
    chown -R $i:$i /home/$i
done
groupadd -f admin
yes "Otus2024!" | passwd otusadm && yes "Otus2024!" | passwd otus && yes "vagrant" | passwd root
for i in {vagrant,root,otusadm}; do usermod -aG admin $i; done
cp -f /vagrant/login.sh /usr/local/bin/
echo "auth required pam_exec.so debug /usr/local/bin/login.sh" >> /etc/pam.d/sshd
echo "otus ALL=NOPASSWD: /usr/bin/systemctl restart docker" > /etc/sudoers.d/otus
usermod -aG docker otus
