#!/bin/bash

set -e

export ACME_DNS_API_BASE="https://api.getlocalcert.net/api/v1/acme-dns-compat"
export ACME_DNS_STORAGE_PATH=/tmp/lego-creds.json

# Register a fresh instant domain
curl -X POST ${ACME_DNS_API_BASE}/register > /tmp/creds.json
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain /tmp/creds.json)
echo "GOT ${ACMEDNS_FULLDOMAIN}"

# LEGO maps the FQDN to the verification domain
# We're going to use the FQDN as the verification domain
# Update the JSON
echo -n '{"'                  >  /tmp/lego-creds.json
echo -n ${ACMEDNS_FULLDOMAIN} >> /tmp/lego-creds.json
echo -n '":'                  >> /tmp/lego-creds.json
cat /tmp/creds.json           >> /tmp/lego-creds.json
echo "}"                      >> /tmp/lego-creds.json

# Validate the JSON
jq . /tmp/lego-creds.json > /dev/null

# Issue a certificate with LE (staging env)
lego \
  --accept-tos \
  --email ${ACMEDNS_EMAIL} \
  --dns acme-dns \
  --domains ${ACMEDNS_FULLDOMAIN} \
  --server https://acme-staging-v02.api.letsencrypt.org/directory \
  run
