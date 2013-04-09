#!/usr/bin/env python
#-*- coding: utf8 -*-
import etherway

def main():
	EtherwayBalance=etherway.EtherwayBalanceFetcher(login="pnumber", password="mygoodpassword")
	mybalance=None
	try:
		mybalance=EtherwayBalance.get_balance()
	except etherway.QueryError as errstr:
		print errstr
		exit(1)
	print mybalance
	exit(0)

if __name__ == "__main__":
	main()
