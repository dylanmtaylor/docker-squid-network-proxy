FROM ubuntu/squid:latest

COPY squid.conf /etc/squid/squid.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
