# docker-squid-network-proxy
Docker squid network proxy with example allowlist file

The allow list needs to be provided to the image as a variable. New lines should be escaped as \n between each entry on the command line.

## Sample Usage
```
docker run --env ALLOW_LIST=".example.com\n.google.com" squid-network-proxy:latest
```