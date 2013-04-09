#!/usr/bin/env bash
###################################
# Скрипт проверки баланса Etherway ru
# Идеей и основой послужило: http://habrahabr.ru/blogs/sysadm/114177/
# Доработан Saymon21, Сбт Сен 10 19:27:55 2011
# saymon<at>hub21<dot>ru
# Требования, libnotify-bin, wget
#####################################
# ВНИМАНИЕ!!!!
# Обязательно установите chmod 600 для файла конфигурации скрипта!
#####################################
#Пример файла настроек (~/.config/lk.etherway.ru.conf):
#       LOGIN="p0100000" # Логин 
#       PASSWORD="mypassword" # Пароль
#       USRAGENT='Opera/9.80 (X11; Linux i686; U; ru) Presto/2.9.168 Version/11.51'
#####################################
source ~/.config/lk.etherway.ru.conf

request()
{
        wget \
         --user-agent="$USRAGENT" \
                --load-cookies cookies.txt \
                --save-cookies cookies.txt \
                --keep-session-cookies \
                --quiet \
        $@ 
}

request -O /tmp/index.html \
        'https://lk.etherway.ru/site/login'
request -O /tmp/form.html \
      --post-data="LoginForm[username]=$LOGIN&LoginForm[password]=$PASSWORD" \
        'https://lk.etherway.ru/site/login' 
request -O /tmp/info.html 'https://lk.etherway.ru/account/info'

get_display () {
 who \
 | grep ${1:-$LOGNAME} \
 | perl -ne 'if ( m!\(\:(\d+)\)$! ) {print ":$1.0\n"; $ok = 1; last} END {exit !$ok}'
 }
export DISPLAY=$(get_display) || exit
CUR_BALANCE=$(cat "/tmp/info.html"| grep "Баланс" | awk -F"<|>" '{print $11}')
notify-send "Etherway.ru" "По состоянию на $(date +%A), $(date +%h) $(date +%d)\n Ваш баланс составляет: ${CUR_BALANCE}" -u critical -i ~/Изображения/icons/ewtt.gif;

rm -f /tmp/{index.html,form.html,info.html,cookies.txt}
