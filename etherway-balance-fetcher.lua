#!/usr/bin/env lua
-- EtherwayBalanceFetcher - Simple Lua script to get balance Etherway.ru 

-- Copyright © 2013 Denis 'Saymon21' Khabarov
-- E-Mail: saymon at hub21 dot ru (saymon@hub21.ru)

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License version 3
-- as published by the Free Software Foundation.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local https = require 'https' -- This from lua-sec library.
local url = require'socket.url'
local ltn12 = require'ltn12'
local cmdarg = {}
local _MYVERSION = '0.1'

function cookie_handler(sData)
	local t,i = {},0
	for name, val in sData:gmatch('(%S-)=(%S-);') do
		if val ~= 'deleted' then
			table.insert(t, {name, val})
			i = i+1
		end
	end
	local val = ''
	for cnt, value in ipairs(t) do
		val = val..value[1]..'='..value[2]
		if cnt ~= i then
			val = val..'; '
		end
	end
	return val
end

function get(login, password)	
	local a, b, c = https.request('https://lk.etherway.ru/site/login')
	if b and b == 200 then
		local source = url.escape('LoginForm[username]')..'='..url.escape(login)..'&'..url.escape('LoginForm[password]')..'='..url.escape(password)
		local a, b, c = https.request({
			method = "POST",
			url = "https://lk.etherway.ru/site/login",
			source = ltn12.source.string(source),
			sink = ltn12.sink.table(tResponse),
			protocol = "tlsv1",
			headers = {
				['Content-Length'] = source:len(),
				["Content-Type"] = "application/x-www-form-urlencoded",
				['Cookie'] = cookie_handler(c["set-cookie"]),
				['Host'] = "lk.etherway.ru",
				['Referer'] = "https://lk.etherway.ru/account/info",
				['User-Agent'] = "Mozilla/5.0 (X11; Linux i686; rv:21.0) Gecko/20100101 Firefox/21.0"
			}
		})
		if b and b == 302 and c['location'] == 'https://lk.etherway.ru/account/info' then
			tResponse = {}
			local a, b, c = https.request({
				method = "GET",
				url = "https://lk.etherway.ru/account/info",
				sink = ltn12.sink.table(tResponse),
				protocol = "tlsv1",
				headers = {
					['Cookie'] = cookie_handler(c["set-cookie"]),
					['Host'] = "lk.etherway.ru",
					['Referer'] = "https://lk.etherway.ru/account/info",
					['User-Agent'] = "Mozilla/5.0 (X11; Linux i686; rv:21.0) Gecko/20100101 Firefox/21.0"
				}
			})
			if b and b == 200 then
				if tResponse[3] and tResponse[3]:len() > 0 then
					local balance = tResponse[3]:match('<div id=\'balance\'>(.+)</div>')
					if balance and balance:len() > 0 then
						local balance_val = balance:match('<span class=%S+>(.+)</span')
						if balance_val then
							return 0, balance_val
						else
							return 1, "Сумма не найдена"
						end
					else
						return 1, "Сумма не найдена"
					end
				else
					return 1, "Ответ не корректен"
				end
			else
				return 1, "Запрос не обработан"
			end
		else
			return 1, "Неверное имя пользователя или пароль"
		end
	else
		return 1, "Запрос не обработан"
	end
end

function show_help()
	print('\tEtherwayBalanceFetcher','version '.._MYVERSION,'Скрипт для получения баланса провайдера Etherway.ru')
	print('\tCopyright © 2013 by Denis Khabarov aka \'Saymon21\'\n\tE-Mail: saymon@hub21.ru')
	print('\tHomepage: http://opensource.hub21.ru/etherwaybalancefetcher/wiki/Home')
	print('\tLicence: GNU General Public License version 3')
	print('\tYou can download full text of the license on http://www.gnu.org/licenses/gpl-3.0.txt\n')
	show_usage()
	print('\n\tOPTIONS:')
	print('\t','--login','VALUE', ': login for auth in lk.etherway.ru')
	print('\t','--password','VALUE',': password for auth in lk.etherway.ru')
	print('\t','--help',': show this help')
	print('\t','--version',': show version')
	
end

function show_usage()
	print(('usage: %s --login=\'VALUE\' --password=\'VALUE\''):format(arg[0]:gsub('./','')))
end

function cliarg_handler()
	if arg then
		local available_args = {['login'] = true, ['password'] = true,['help']=true,['version']=true}
		for _, val in ipairs(arg) do
			if val:find("=", 1, true) then
				local name, value = val:match("%-%-(.-)=(.+)")
					if name and value and available_args[name:lower()] then
						cmdarg[name:lower()] = value
					else
						print("Unknown commandline argument used: "..val)
						show_usage()
						os.exit(1)
					end
			else
				name = val:match("%-%-(.+)")
				if name and  available_args[name:lower()] then
					cmdarg[name:lower()] = true
				else
					print("Unknown commandline argument used: "..val)
					show_usage()
					os.exit(1)
				end
			end
		end
		if cmdarg['help'] then
			show_help()
			os.exit(0)
		end
		if cmdarg['version'] then
			print(('etherway-balance-fetcher version: %s'):format(_MYVERSION))
			print(('Lang version: %s'):format(_VERSION))
			os.exit(0)
		end
	end
end       

function get_os()
	local path_separator = package.config:sub(1,1)
	if path_separator == '/' then
		return 1 -- Unix
	elseif path_separator == '\\' then
		return 2 -- Win
	end
end

function get_home_path()
	local _os = get_os()
	if _os == 1 then
		home = os.getenv('HOME')
	elseif _os == 2 then
		home = os.getenv("USERPROFILE")
	else 
		os.exit(1)
	end
	return home
end

function check_rc_access()
	if get_os() == 1 then
		local posix = require'posix'
		local home = get_home_path()
		for index,value in pairs(posix.stat(home..'/.etherwaybalancefetcherrc')) do
			if index == 'mode' and value ~= 'rw-------' then
				print('\''..home..'/.etherwaybalancefetcherrc\' must not be accessible by others (Use: \'chmod 600 '..home..'/.etherwaybalancefetcherrc\')')
				os.exit(1)
			end
		end
	end
end

function read_rc()
	local home = get_home_path()
	if home then
		h=io.open(home..'/.etherwaybalancefetcherrc','r')
		if h then
			data=h:read()
		end
	end
	if data then
		local login, password = data:match('(.+):(.+)')
		if login and password then
			return login, password	 
		end
	end		
end

function main()
	cliarg_handler()
	if not cmdarg.login or not cmdarg.password then
		local login, password = read_rc()
		if login and password then
			check_rc_access()
			cmdarg.login = login
			cmdarg.password = password
		else
			print('Error. Login and password not found!')
			os.exit(1)
		end
	end
	if type(cmdarg.login) ~= 'string' or type(cmdarg.password) ~= 'string' then
		print('Invalid login or password')
		os.exit(1)
	end
	local result,info = get(cmdarg.login,cmdarg.password)
	if result and result == 0 then
		print(('Ваш баланс равен %s'):format(info))
		os.exit(0)
	elseif result and result == 1 then
		print(('ПРОИЗОШЛА ОШИБКА: %s'):format(info))
		os.exit(1)
	else
		print('UNKNOWN ERROR')
		os.exit(1)
	end
end

if type(arg) == 'table' then -- Python-style: if __name__ == "__main__" (I hope this is adequate)
	main()
else
	error('Calling the this script as a module for the programming language, it\'s not a good idea.')
end
