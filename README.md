������� python ������ ��� ��������� ������� � ������� �������� ���������� http://etherway.ru.
�����: Saymon21
��������: GNU GPLv3
etherway.py, etherwaypy3.py - ��� ������.
example.py, examplepy3.py - ������� ������������� ������.
old-etherway-with-libnotify.sh, old.sh - ������, ����� ������ ������ �������. �������� �� Bash. 
��� Python 2.x ������������: etherway.py, example.py 
��� Python 3.2 ������������: etherwaypy3.py, examplepy3.py
example* - ������� ����� ��� ������������ ��� ������ ������� �������� �� ������� ����, ��������� conky, libnotify et� � Linux ��������.
� ����� ���������� ���� �� ��� ���� � Nagios, Munin etc. �� ������� ������ �� ������ �����������. 8)

������, ����� �������� �� �������� ��������� � example ��������:

EtherwayBalance=etherway.EtherwayBalanceFetcher(login="pnumber", password="mygoodpassword")

EtherwayBalance=etherwaypy3.EtherwayBalanceFetcher(login="pnumber", password="mygoodpass")

������ pnumber - ����� � ������� ��������, ������ mygoodpass ������.
����� �������������� ����������� ���������, ����� ����� � ������ ��� ����������.
������ �� �������� ���������� �� ������ ������ � ������ �/��� ������. 
��� REST-�� ������� ������� �������� ��������� ����� �������� ���������� �� ��� ����� ��������� ����������.
Windows XP:
��������: http://www.python.org/ftp/python/2.7.3/python-2.7.3.msi
��� http://www.python.org/ftp/python/2.7.3/pyt...2.7.3.amd64.msi
������������� � C:\Python27\
���� � ����������� etherway.py � ��������� � C:\Python27\Lib\etherway.py
��������� example.py
� �������
EtherwayBalance=etherway.EtherwayBalanceFetcher(login="pnumber", password="mygoodpassword")

��������� ���� ����� � ������.
����-��������� cmd:

cd C:\
example.py

��� ���� ������ � ���� �� ������� ���������, ��� ������� ��� ������. 8)

