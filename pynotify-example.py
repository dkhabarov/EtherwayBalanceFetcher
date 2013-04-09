#!/usr/bin/env python2.6
#-*- coding: utf8 -*-
from sys import stderr, exit
from os.path import isfile, islink
from os import environ, getcwd

try:
	import pynotify, etherway
except ImportError as errstr:
	print >> sys.stderr, errstr
	sys.exit(1)

def main():
	img_path="/usr/share/icons/etherway-logo.png"
	if (isfile(img_path) == False) or (islink(img_path) == False):
		img_path ="%s/etherway-logo.png" %(getcwd())
	if not environ.has_key('DISPLAY'):
		environ['DISPLAY']=':0'
	
	if pynotify.init("EtherwayBalanceFetcher"):
		EtherwayBalance=etherway.EtherwayBalanceFetcher(login="pnumber", password="mygoodpassword")
		try:
			balance = EtherwayBalance.get_balance()
		except etherway.QueryError as errstr:
			print >> stderr, errstr
			exit(1)
		notify = pynotify.Notification("Etherway.ru", "Ваш баланс: %s %s" % (balance[0],balance[1]), img_path)
		notify.set_urgency(pynotify.URGENCY_NORMAL)
		notify.set_timeout(pynotify.EXPIRES_NEVER)
		notify.show()
	else:
		print >> stderr, "problem initializing the pynotify module"
		exit(1)


if __name__ == "__main__":
	main()
