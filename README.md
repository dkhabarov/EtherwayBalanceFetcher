Простой python модуль для получения баланса с личного кабинета провайдера http://etherway.ru.
Автор: Saymon21
Лицензия: GNU GPLv3
etherway.py, etherwaypy3.py - Сам модуль.
example.py, examplepy3.py - Примеры использования модуля.
old-etherway-with-libnotify.sh, old.sh - Старая, самая первая версия скрипта. Написана на Bash. 
Для Python 2.x использовать: etherway.py, example.py 
Для Python 3.2 использовать: etherwaypy3.py, examplepy3.py
example* - скрипты можно уже использовать для вывода баланса например на рабочий стол, используя conky, libnotify etс в Linux системах.
А можем прикрутить даже всё это дело к Nagios, Munin etc. Всё зависит только от вашего воображения. 8)

Кстати, перед запуском не забываем указывать в example скриптах:

EtherwayBalance=etherway.EtherwayBalanceFetcher(login="pnumber", password="mygoodpassword")

EtherwayBalance=etherwaypy3.EtherwayBalanceFetcher(login="pnumber", password="mygoodpass")

Вместо pnumber - логин к личному кабинету, вместо mygoodpass пароль.
Перед использованием обязательно проверьте, чтобы логин и пароль был правильным.
Модуль не вызывает исключения на случай ошибки в пароле и/или логине. 
Без REST-со стороны личного кабинета обработка таких ситуаций превратила бы код самый настоящий макаронный.
Windows XP:
Качиваем: http://www.python.org/ftp/python/2.7.3/python-2.7.3.msi
Или http://www.python.org/ftp/python/2.7.3/pyt...2.7.3.amd64.msi
Устанавливаем в C:\Python27\
Берём с репозитория etherway.py и сохраняем в C:\Python27\Lib\etherway.py
Открываем example.py
В строчке
EtherwayBalance=etherway.EtherwayBalanceFetcher(login="pnumber", password="mygoodpassword")

Вписываем свой логин и пароль.
Пуск-выполнить cmd:

cd C:\
example.py

Ждём пару секунд и если всё сделали правильно, нам покажет наш баланс. 8)

