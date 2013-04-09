#!/usr/bin/env python
#-*- coding: utf8 -*-
"""
##########################################################################
 nagios_check_etherway_balance.py - Plugin for nagios to check balance privider Etherway.ru

 Copyright © 2009-2012 Denis 'Saymon21' Khabarov
 E-Mail: <saymon@hub21.ru>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License version 3
 as published by the Free Software Foundation.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
##########################################################################
"""
"""
Nagios command config:

define command {
	command_name check_etherway_ru_balance
	command_line /usr/lib/nagios/plugins/nagios_check_etherway_balance.py --user='$ARG1$' --password='$ARG2$' --warning='$ARG3$' --critical='$ARG4$'
}

Nagios service config:

define service {
    service_description             Etherway.ru Balance
    host_name                       localhost
    check_command                   check_etherway_ru_balance!p00001!mysuperpassword!30!15
    use                             generic-service
}

"""
##########################################################################
import argparse, sys
try:
	if sys.version_info[0] == 2:
		import etherway as ew
	elif sys.version_info[0] == 3:
		import etherwaypy3 as ew
except ImportError:
	print >> sys.stderr, "Unable to import etherway module. See http://opensource.hub21.ru/etherwaybalancefetcher/wiki/Home"
	sys.exit(3)

cliparser = argparse.ArgumentParser(prog=sys.argv[0],description='''Plugin for nagios to check balance privider Etherway.ru
Copyright © 2009-2012 Denis 'Saymon21' Khabarov
E-Mail: saymon at hub21 dot ru (saymon@hub21.ru)\r\nLicence: GNU GPLv3''',formatter_class=argparse.RawDescriptionHelpFormatter)
cliparser.add_argument("--warning",metavar="VALUE",help="warning RUB",required=True)
cliparser.add_argument("--critical",metavar="VALUE",help="critical RUB",required=True)
cliparser.add_argument("--user",metavar="VALUE", help="login for auth in lk.etherway.ru",required=True)
cliparser.add_argument("--password",metavar="VALUE",help="password for auth in lk.etherway.ru",required=True)
cliargs = cliparser.parse_args()

def main():
	lk=ew.EtherwayBalanceFetcher(login=cliargs.user, password=cliargs.password)
	try:
		mybalance=lk.get_balance()
	except ew.QueryError as errstr:
		print(errstr)
		sys.exit(3)
	
	lbalance=mybalance.split(".")
	if lbalance[0]:
		rub=int(lbalance[0])
		if int(cliargs.critical) >= rub:
			print("CRITICAL Balance = "+str(rub)+" RUB")
			sys.exit(2)
		elif int(cliargs.warning) >= rub:
			print("WARNING Balance = "+str(rub)+" RUB")
			sys.exit(1)
		else:
			print("OK. Balance = "+str(rub)+" RUB")
			sys.exit(0)
	else:
		print("UNKNOWN")
		sys.exit(3)
		
		 
if __name__ == "__main__":
	main()
