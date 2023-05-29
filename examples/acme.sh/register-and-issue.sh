#!/bin/bash

set -e

export LOCALCERT_API=https://api.getlocalcert.net/api/v1
export ACMEDNS_BASE_URL=${LOCALCERT_API}/acme-dns-compat

# Register a fresh instant domain (when needed)
if [ ! -s creds.json ]; then
  curl -X POST ${LOCALCERT_API}/register > creds.json
fi

# Issue a certificate with LE (staging env)
export ACMEDNS_SUBDOMAIN=$(jq -r .subdomain creds.json)
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain creds.json)
export ACMEDNS_USERNAME=$(jq -r .username creds.json)
export ACMEDNS_PASSWORD=$(jq -r .password creds.json)
~/.acme.sh/acme.sh --issue --dns dns_acmedns -d ${ACMEDNS_FULLDOMAIN} --staging

