Домашнее задание

    Systemd - создание unit-файла

Цель:

    Научиться редактировать существующие и создавать новые unit-файлы

Что нужно сделать?

    1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
    2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно также называться.
    3. Дополнить юнит-файл apache httpd возможностью запустить несколько инстансов сервера с разными конфигами

В данной работе был использован Debian 12.

После запуска ОС выполняются следующие команды:

Установка необходимых для ДЗ пакетов:

    apt install -y apache2 wget rsyslog spawn-fcgi php php-cgi php-cli

Создаем необходимые для сервиса файлы и помещаем их в нужные папки. Для Debian 12 директория /etc/sysconfig заменена на /etc/default, а /usr/lib/systemd/system и /etc/systemd/system на /lib/systemd/system

    wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.timer -O /lib/systemd/system/watchlog.timer
    wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.sh -O /opt/watchlog.sh
    wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.log -O /var/log/watchlog.log
    chmod +x /opt/watchlog.sh
    wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog.service -O /lib/systemd/system/watchlog.service
    wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/watchlog -O /etc/default/watchlog

Запускаем сервис, таймер и проверяем нужный нам вывод в логах системы:

    systemctl start watchlog.service && systemctl start watchlog.timer
    cat /var/log/syslog | grep Master

Создаем необходимые файлы для сервиса spawn-fcgi:

    wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/spawn-fcgi.service -O /lib/systemd/system/spawn-fcgi.service
    wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/spawn-fcgi -O /etc/default/spawn-fcgi

Запускаем сервис и проверяем его статус:

    systemctl start spawn-fcgi && systemctl status spawn-fcgi

Для Apache2 существует специальный скрипт, позволяющий одной командой создать дополнительный экземпляр сервиса без критического изменения конфигурационных файлов. Для запуска доп. сервисов необходимо только переназначить порты, что и представлено в цикле. Поэтому назначаем права доступа данному скрипту, запускаем его и создаем два дополнительных экземпляра сервиса Apache2:

    chmod +x /usr/share//doc/apache2/examples/setup-instance
    for i in {1,2}; do
        /usr/share/doc/apache2/examples/setup-instance $i
        wget https://raw.githubusercontent.com/Rolllz/teaching/SYSTEMD/$i-ports.conf -O /etc/apache2-$i/ports.conf
        systemctl start apache2@$i && systemctl status apache2@$i
    done
