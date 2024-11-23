#!/bin/bash

set -e

export LOCALCERT_API=https://api.getlocalcert.net/api/v1
export ACMEDNS_BASE_URL=${LOCALCERT_API}/acme-dns-compat

# Register a fresh instant domain (when needed)
if [ ! -s creds.json ]; then
  curl -X POST ${LOCALCERT_API}/register > creds.json
fi

# Issue a certificate
export ACMEDNS_SUBDOMAIN=$(jq -r .subdomain creds.json)
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain creds.json)
export ACMEDNS_USERNAME=$(jq -r .username creds.json)
export ACMEDNS_PASSWORD=$(jq -r .password creds.json)

# First staging environment
~/.acme.sh/acme.sh --issue --dns dns_acmedns --force -d ${ACMEDNS_FULLDOMAIN} --staging

# Cleanup
~/.acme.sh/acme.sh --remove -d ${ACMEDNS_FULLDOMAIN} --staging

if [[ $1 == "prod" ]]; then
  # Try prod if staging worked (force Let's Encrypt)
  # Only do this on a cron schedule, so we don't consume too much of the rate limit
  ~/.acme.sh/acme.sh --issue --dns dns_acmedns --force -d ${ACMEDNS_FULLDOMAIN} --server letsencrypt
fi

