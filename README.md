  Домашнее задание. Пишем скрипт
  
  Цель домашнего задания:
  Написать скрипт на языке Bash.
  
  Описание домашнего задания:
    Написать скрипт для CRON, который раз в час будет формировать письмо и отправлять на заданную почту.
  
  Необходимая информация в письме:

    - Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
    - Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
    - Ошибки веб-сервера/приложения c момента последнего запуска;
    - Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
    - Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.

    В письме должен быть прописан обрабатываемый временной диапазон.

  В данном ДЗ был использован Debian 12.

  В качестве механизма предотвращения одновременного запуска скрипта используется утилита flock:

    (
    flock -n 9 || exit 1

  Определяем переменную с лог-файлом и записываем в другую переменную его содержимое:

    LOGFILE=/var/log/apache2/access.log
    LOGDATA=$(cat $LOGFILE)

  Вычисляем текущую дату и время, а также из файла, создаваемого этим скриптом, считываем дату последнего запуска скрипта, и вычисляем те строки, которые нам действительно необходимо обработать:

    CURTIME=$(date)
    LASTTIME=''
    if [ -f ~/run_date.txt ]; then
        LASTTIME=$(date -f ~/run_date.txt +%s)
        dates=($(printf "%s\n" "$LOGDATA" | awk '{print substr($4,2,20)}'))
        for i in ${!dates[@]}; do
            if [[ $(date -d "$(echo ${dates[$i]} | sed -e 's,/,-,g' -e 's,:, ,')" +"%s") -lt $LASTTIME ]]; then
                number_of_string=$i
                break
            fi
        done
        LASTTIME=$(date -u -d @${LASTTIME})
        LOGDATA=$(printf "%s\n" "$LOGDATA" | grep -A $((${#dates[*]}-$number_of_string)) "${dates[$i]}")
        unset dates
    else
        LASTTIME=$CURTIME
    fi
    echo $CURTIME > ~/run_date.txt
    printf "Временной промежуток:\n$LASTTIME\n$CURTIME\n" > ~/time.txt

  Определяем функцию, которая вычисляет максимальное количество повторений в массиве и выдает в выходной поток значения элементов массива с данным количеством повторений. Проще говоря, определяем моду (или моды в случае нескольких наиболее часто встречаемых значений) в заданном ряде значений:

    list() {
        maxval=$(printf '%s\n' "$@" | sort | uniq -c | sort -n | tail -1 | awk '{print $1}')
        printf '%s\n' "$@" | sort | uniq -c | sed 's/^ \{1,\}//g' | grep "$maxval " | sed "s/ /\t/g"
    }

  Определяем IP-адреса и URL'ы с наибольшим количеством запросов:
  
    tip="IP"
    ip_addrs=($(printf '%s\n' "$LOGDATA" | awk '{print $1}'))
    list_ip=$(list ${ip_addrs[@]})
    printf "Count\t$tip\n" > ~/list_$tip.txt
    printf "%s\n" "${list_ip}" >> ~/list_$tip.txt
    tip="URL"
    urls=($(printf '%s\n' "$LOGDATA" | awk '{print $7}'))
    list_url=$(list ${urls[@]})
    printf "Count\t$tip\n" > ~/list_$tip.txt
    printf "%s\n" "${list_url}" >> ~/list_$tip.txt

  Определяем список кодов HTTP-ответа и вычисляем частоту встречаемости каждого из кодов:
  
    printf "Count\tRequest\n" > ~/list_requests.txt
    printf '%s\n' "$LOGDATA" | awk '{print $9}' | sort | uniq -c | sed "s/^ \{1,\}//g" >> ~/list_requests.txt

  Указываем почтовый адрес получателя электронного письма, формируем заголовок и тело письма и отправляем:

    recipient="unknownmail@gmail.com"
    subject="Apache2 statistics"
    cat ~/time.txt ~/list_IP.txt ~/list_URL.txt ~/list_requests.txt | mailx -s "$subject" "$recipient"

  Ну и завершаем часть с предотвращением одновременного выполнения скрипта:

    ) 9>/var/lock/mylockfile

ВАЖНО!!! ПЕРЕД ВЫПОЛНЕНИЕМ СКРИПТА УБЕДИТЬСЯ В ТОМ, ЧТО ВСЕ НЕОБХОДИМЫЕ УТИЛИТЫ ДЛЯ РАБОТЫ С ЭЛЕКТРОННОЙ ПОЧТОЙ УСТАНОВЛЕНЫ И НАСТРОЕНЫ!!!
