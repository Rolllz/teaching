#!/bin/bash
set -euxo pipefail

(
flock -n 9 || exit 1

LOGFILE=./access.log
LOGDATA=$(cat $LOGFILE)

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

list() {
    maxval=$(printf '%s\n' "$@" | sort | uniq -c | sort -n | tail -1 | awk '{print $1}')
    printf '%s\n' "$@" | sort | uniq -c | sed 's/^ \{1,\}//g' | grep "$maxval " | sed "s/ /\t/g"
}

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
printf "Count\tRequest\n" > ~/list_requests.txt
printf '%s\n' "$LOGDATA" | awk '{print $9}' | sort | uniq -c | sort -n | sed "s/^ \{1,\}//g; s/ /\t/g" >> ~/list_requests.txt


recipient="unknownmail@gmail.com"
subject="Apache2 statistics"
cat ~/time.txt ~/list_IP.txt ~/list_URL.txt ~/list_requests.txt | mailx -s "$subject" "$recipient"

) 9>/var/lock/mylockfile
