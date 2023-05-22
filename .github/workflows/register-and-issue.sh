#!/bin/bash

# Get a fresh instant domain
curl -X POST https://api.getlocalcert.net/api/v1/acme-dns-compat/register > /tmp/creds.json

# Register with LE staging
export ACMEDNS_SUBDOMAIN=$(jq -r .subdomain /tmp/creds.json)
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain /tmp/creds.json)
export ACMEDNS_USERNAME=$(jq -r .username /tmp/creds.json)
export ACMEDNS_PASSWORD=$(jq -r .password /tmp/creds.json)
~/.acme.sh/acme.sh --issue --debug --dns dns_acmedns -d ${ACMEDNS_FULLDOMAIN} --staging

