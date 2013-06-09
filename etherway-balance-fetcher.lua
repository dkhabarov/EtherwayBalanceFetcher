#!/usr/bin/env lua
-- EtherwayBalanceFetcher - Simple Lua script to get balance Etherway.ru 

-- Copyright © 2012 Denis 'Saymon21' Khabarov
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
						local balance_val = balance:match('<span class=green>(.+)</span')
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
	print('\tEtherwayBalanceFetcher','Скрипт для получения баланса провайдера Etherway.ru')
	print('\tAuthor Denis \'Saymon21\' Khabarov (saymon@hub21.ru)')
	print('\tLicence: GNU GPLv3')
	print('\n\tOPTIONS:')
	print('\t','--login','VALUE', '- login for auth in lk.etherway.ru')
	print('\t','--password','VALUE','- password for auth in lk.etherway.ru')
	print('\t','--help','- show this help')
	print('\n')
	show_usage()
end

function show_usage()
	print(('usage: %s --login=\'VALUE\' --password=\'VALUE\''):format(arg[0]:gsub('./','')))
end

function cliarg_handler()
	if arg then
		local available_args = {['login'] = true, ['password'] = true,['help']=true}
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
		if type(cmdarg['login']) ~= 'string' then
			print('Invalid value for argument --login')
			show_usage()
			os.exit(1)
		end
		if type(cmdarg['password']) ~= 'string' then
			print('Invalid value for argument --password')
			show_usage()
			os.exit(1)
		end
	end
end       

function main()
	cliarg_handler()
	local result,info = get(cmdarg['login'],cmdarg['password'])
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

if arg and type(arg) == 'table' then
	main()
end
