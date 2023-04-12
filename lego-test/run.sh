#!/bin/bash

export ACME_DNS_STORAGE_PATH=./credentials.json
export ACME_DNS_API_BASE=https://api.getlocalcert.net/api/acmedns/v1
./lego --accept-tos --email moonrockseven@gmail.com --dns acme-dns --domains 1.localhostcert.net --server https://acme-staging-v02.api.letsencrypt.org/directory run

# error: it looks like this tries to setup a new account?
# needs debugging

