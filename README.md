# docker-squid-network-proxy
Docker squid network proxy that takes allow list as an environment variable argument.
New lines should be escaped as \n between each entry on the command line.
Each server should have a new line after it, and if you want to include subdomains, the entry should be preceeded by `.`.

## Sample Usage
```
docker run --env ALLOW_LIST=".example.com\n.google.com\n" squid-network-proxy:latest
```
