#!/bin/bash

set -e

export LOCALCERT_API=https://api.getlocalcert.net/api/v1
export ACME_DNS_API_BASE=${LOCALCERT_API}/acme-dns-compat
export ACME_DNS_STORAGE_PATH=/tmp/lego-creds.json

# Register a fresh instant domain
curl -X POST -F output_format=lego ${LOCALCERT_API}/register > ${ACME_DNS_STORAGE_PATH}
export ACMEDNS_FULLDOMAIN=$(jq -r keys[0] ${ACME_DNS_STORAGE_PATH})
echo "Got ${ACMEDNS_FULLDOMAIN}"

# Issue a certificate with LE (staging env)
# Get both the subdomain and a wildcard for the new subdomain
./lego \
  --accept-tos \
  --email ${ACMEDNS_EMAIL} \
  --dns acme-dns \
  --domains ${ACMEDNS_FULLDOMAIN} \
  --domains *.${ACMEDNS_FULLDOMAIN} \
  --server https://acme-staging-v02.api.letsencrypt.org/directory \
  run
