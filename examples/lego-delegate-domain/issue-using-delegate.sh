#!/bin/bash

set -e

export ACME_DNS_API_BASE="https://api.getlocalcert.net/api/v1/acme-dns-compat"
export ACME_DNS_STORAGE_PATH=/tmp/lego-creds.json

# Get the creds from GitHub secrets
echo "${ALEXSCI_JSON}" > ${ACME_DNS_STORAGE_PATH}

lego \
  --accept-tos \
  --email ${ACMEDNS_EMAIL} \
  --dns acme-dns \
  --domains test-acme-delegate.alexsci.com \
  --server https://acme-staging-v02.api.letsencrypt.org/directory \
  --dns.disable-cp \
  run

