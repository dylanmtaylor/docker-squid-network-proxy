FROM ubuntu/squid:latest

COPY squid.conf /etc/squid/squid.conf
COPY allow_list.txt /etc/squid/allow_list.txt
