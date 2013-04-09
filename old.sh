#!/bin/sh
###################################
# Скрипт проверки баланса Etherway ru
# Идеей и основой послужило: http://habrahabr.ru/blogs/sysadm/114177/
# Доработан Saymon21, Сбт Сен 10 19:27:55 2011
# admin<at>hub21<dot>ru or ewsaymon<at>yandex<dot>ru
# Требования, wget
###################################
############ Настройки скрипта ######
LOGIN="p0000000"
PASSWORD="pass"
USRAGENT='Opera/9.80 (X11; Linux i686; U; ru) Presto/2.9.168 Version/11.51'
############ Настройки скрипта ######
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

request -O index.html \
        'https://lk.etherway.ru/site/login'
request -O form.html \
      --post-data="LoginForm[username]=$LOGIN&LoginForm[password]=$PASSWORD" \
        'https://lk.etherway.ru/site/login' 
request -O info.html 'https://lk.etherway.ru/account/info'


CUR_BALANCE=$(cat "info.html"| grep "Баланс" | awk -F"<|>" '{print $11}')
echo "$CUR_BALANCE"
#####################
rm -f index.html
rm -f form.html
rm -f info.html
