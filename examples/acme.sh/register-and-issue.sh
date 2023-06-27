#!/bin/bash

set -e

acme_sh_extra_flags=""

while [ ${#} -gt 0 ]; do
  case "${1}" in
  --staging)
    acme_sh_extra_flags+=" --staging "
    ;;
  *)
    echo "Unknown parameter : $1"
    exit 1
    ;;
  esac
  shift 1
done


export LOCALCERT_API=https://api.getlocalcert.net/api/v1
export ACMEDNS_BASE_URL=${LOCALCERT_API}/acme-dns-compat

# Register a fresh instant domain
curl -X POST ${LOCALCERT_API}/register > /tmp/creds.json

# Issue a certificate with LE (staging env)
export ACMEDNS_SUBDOMAIN=$(jq -r .subdomain /tmp/creds.json)
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain /tmp/creds.json)
export ACMEDNS_USERNAME=$(jq -r .username /tmp/creds.json)
export ACMEDNS_PASSWORD=$(jq -r .password /tmp/creds.json)

~/.acme.sh/acme.sh --issue --dnssleep 1 --dns dns_acmedns --force -d ${ACMEDNS_FULLDOMAIN} ${acme_sh_extra_flags}

# Cleanup for repeated runs
~/.acme.sh/acme.sh --remove -d ${ACMEDNS_FULLDOMAIN} ${acme_sh_extra_flags}

