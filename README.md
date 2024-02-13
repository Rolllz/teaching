Домашнее задание

    Размещаем свой RPM в своем репозитории

Цель:

    - создавать свой RPM;
    - создавать свой репозиторий с RPM;

Что нужно сделать?

    - создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями);
    - создать свой репо и разместить там свой RPM;
    - реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо.

В данной работы была использована ОС Centos 8 stream. В качестве пакета будет собрано просто Go-приложение, создающее веб-сервер, висящий на порту 8081.

После запуска ОС выполняются следующие команды:

Установка необходимых для работы пакетов, модулей и групп:

    yum install -y git nginx createrepo
    yum module install -y go-toolset
    yum group install -y "RPM Development Tools"

Создаем дерево разработки:

    rpmdev-setuptree

Клонируем данный репозиторий и переходим в папку с ним:

    git clone --branch=RPM https://github.com/Rolllz/teaching/ && cd teaching
    
Создаем архив с необходимыми для работы файлами, копируем SPEC файл и перемещаем архив в нужные директории:

    mkdir my_app-1.0 && mv {"config.json","go.mod","main.go","my_app.service","my_app.spec"} my_app-1.0/
    tar -c ./my_app-1.0/ -zvf my_app-1.0.tar.gz
    cp my_app-1.0/my_app.spec ~/rpmbuild/SPECS/
    mv my_app-1.0.tar.gz ~/rpmbuild/SOURCES/

Собираем RPM:
    
    rpmbuild -ba ~/rpmbuild/SPECS/my_app.spec

Создаем папку с репозиторием, копируем туда только что созданный пакет и загружаем еще один пакет из интернета:

    mkdir /usr/share/nginx/html/repo
    cp ~/rpmbuild/RPMS/x86_64/my_app-1.0-1.el8.x86_64.rpm /usr/share/nginx/html/repo/
    wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm

Создаем репозиторий:

    createrepo /usr/share/nginx/html/repo

Добавляем в файл nginx.conf необходиме директивы для работы репозитория и перезагружаем веб-сервер:
    
    sed -i "s/location \/ {/location \/ { root \/usr\/share\/nginx\/html;index index.html index.htm;autoindex on;/g" /etc/nginx/nginx.conf
    systemctl restart nginx

Добавляем репозиторий в пакетный менеджер:
    
    cat >> /etc/yum.repos.d/otus.repo << EOF
    [otus]
    name=otus-linux
    baseurl=http://localhost/repo
    gpgcheck=0
    enabled=1
    EOF

Проверяем доступность репозитория и смотрим, какие пакеты там есть:
    
    yum repolist enabled | grep otus
    yum list | grep otus

Устанавливаем наше веб-приложение, запускаем его и проверяем работоспособность:
    
    yum install my_app -y
    systemctl start my_app.service
    curl -L http://localhost:8081
