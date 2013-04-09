#!/usr/bin/env python3.2
#-*- coding: utf8 -*-
import etherwaypy3

def main():
        EtherwayBalance=etherwaypy3.EtherwayBalanceFetcher(login="pnumber", password="mygoodpass")
        mybalance=None
        try:
                mybalance=EtherwayBalance.get_balance()
        except etherwaypy3.QueryError as errstr:
                print (errstr)
                exit(1)
        print(mybalance)
        exit(0)

if __name__ == "__main__":
        main()
