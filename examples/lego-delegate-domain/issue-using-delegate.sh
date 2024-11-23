#!/bin/bash

set -e

# I have an existing domain name with it's _acme-challenge label pointed at a
# previously registered getlocalcert domain. This allows me to register
# certificates for the existing domain name using getlocalcert as a delegate.
#
# See:
# dig TXT _acme-challenge.test-acme-delegate.alexsci.com

export ACME_DNS_API_BASE="https://api.getlocalcert.net/api/v1/acme-dns-compat"
export ACME_DNS_STORAGE_PATH=creds.json

# Get the creds from GitHub secrets
echo "${ALEXSCI_JSON}" > ${ACME_DNS_STORAGE_PATH}

# Get a certificate and wildcard certificate for the domain
./lego \
  --accept-tos \
  --email ${ACMEDNS_EMAIL} \
  --dns acme-dns \
  --domains acme-dns-delegate-test.alexsci.com \
  --domains *.acme-dns-delegate-test.alexsci.com \
  --server https://acme-staging-v02.api.letsencrypt.org/directory \
  run

