#!/usr/bin/env python3.2
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
__version__ = "0.1"
__maintainer__ = "Denis 'Saymon21' Khabarov"
__email__ = "saymon@hub21.ru"
__status__ = "Development"
try:
	import urllib.request, urllib.parse, re
except ImportError as errstr:
	print (errstr)
	exit(1)

class QueryError(Exception):
	def __init__(self, value):
		self.value = value
	def __str__(self):
		return repr(self.value)

class EtherwayBalanceFetcher:
	def __init__(self, login, password, timeout = 10):
		self.login = login
		self.password = password
		self.timeout = timeout
		if self.login is None:
			raise QueryError("Please enter login!")
		if self.password is None:
			raise QueryError("Please enter password!")
		
	def auth(self):
		urllib.request.install_opener(urllib.request.build_opener(urllib.request.HTTPCookieProcessor))
		params = urllib.parse.urlencode({'LoginForm[username]': self.login, 'LoginForm[password]': self.password})
		req = urllib.request.Request('https://lk.etherway.ru/site/login', params.encode())
		try:
			result = urllib.request.urlopen(req,timeout = self.timeout)
		except (urllib.request.URLError,urllib.request.HTTPError) as errstr:
			raise QueryError(errstr)
		text = result.read()
		return text.decode()

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
