#!/usr/bin/env python
#-*- coding: utf8 -*-
# EtherwayBalanceFetcher - Simple Python script to get balance Etherway.ru 

# Copyright © 2012 Denis 'Saymon21' Khabarov
# E-Mail: saymon at hub21 dot ru (saymon@hub21.ru)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


__author__ = "Denis 'Saymon21' Khabarov"
__copyright__ = "Copyright © 2012 Denis 'Saymon21' Khabarov"
__credits__ = []
__license__ = "GPLv3"
__version__ = "0.2"
__maintainer__ = "Denis 'Saymon21' Khabarov"
__email__ = "saymon@hub21.ru"
__status__ = "Development"
try:
	import urllib, urllib2, re
except ImportError as errstr:
	print errstr
	exit(1)

class QueryError(Exception):
	def __init__(self, value):
		self.value = value
	def __str__(self):
		return repr(self.value)

class EtherwayBalanceFetcher:
	def __init__(self, login, password, timeout = 10):
		if login is None:
			raise QueryError('Login is None, but expected string')
		if password is None:
			raise QueryError('Password is None, but expected string')
		self.login = login
		self.password = password
		self.timeout = timeout

	def auth(self):
		urllib2.install_opener(urllib2.build_opener(urllib2.HTTPCookieProcessor))
		params = urllib.urlencode({'LoginForm[username]': self.login, 'LoginForm[password]': self.password})
		request = urllib2.Request('https://lk.etherway.ru/site/login', params)
		try:
			result = urllib2.urlopen(request, timeout = self.timeout)
		except (urllib2.URLError,urllib2.HTTPError) as errstr:
			raise QueryError(errstr)
		return result.read()

	def get_balance(self):
		source = self.auth()
		if source:
			sbalobj=re.search("<div id='balance'>.+<span class=\S+>(.+)</span>", source)
			if sbalobj is not None:
				balance=sbalobj.group(1).split(" ")
				if balance[0] is not None:				
					return balance
			else:
				raise QueryError('Not found')
				
				
# Example usage:
# ./etherway.py mylogin mypassword				
if __name__ == "__main__":
	import sys
	if not len(sys.argv) < 3:
		fetcher = EtherwayBalanceFetcher(login = sys.argv[1],password = sys.argv[2])
		try:
			data = fetcher.get_balance()
		except QueryError as err_msg:
			print('Error: ' + str(err_msg))
			sys.exit(1)	
		print('Your balance: ' + str(data[0]))
		sys.exit(0)
	else:
		print('Usage ' + sys.argv[0] + ' login password')
		sys.exit(1)
