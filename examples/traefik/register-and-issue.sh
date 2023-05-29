#!/bin/bash

set -e

export LOCALCERT_API=https://api.getlocalcert.net/api/v1

# Register a fresh instant domain (when needed)
if [ ! -s creds.json ]; then
  curl -X POST -F output_format=lego ${LOCALCERT_API}/register > creds.json
fi
export ACMEDNS_FULLDOMAIN=$(jq -r keys[0] creds.json)
echo "Got ${ACMEDNS_FULLDOMAIN}"

# Patch the docker compose config to reference the domain
sed -i "s/YOUR_FQDN_HERE/${ACMEDNS_FULLDOMAIN}/" docker-compose.yml

# Start traefik, routing the new domain to a basic HTTP service
# traefik will automate issuance of a Let's Encrypt (staging) certificate
docker compose up -d

