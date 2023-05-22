#!/bin/bash

export ACMEDNS_BASE_URL=https://api.getlocalcert.net/api/v1/acme-dns-compat

# Register a fresh instant domain
curl -X POST ${ACMEDNS_BASE_URL}/register > /tmp/creds.json

# Issue a certificate with LE (staging env)
export ACMEDNS_SUBDOMAIN=$(jq -r .subdomain /tmp/creds.json)
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain /tmp/creds.json)
export ACMEDNS_USERNAME=$(jq -r .username /tmp/creds.json)
export ACMEDNS_PASSWORD=$(jq -r .password /tmp/creds.json)
~/.acme.sh/acme.sh --issue --dns dns_acmedns -d ${ACMEDNS_FULLDOMAIN} --staging

