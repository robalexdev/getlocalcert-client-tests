#!/bin/bash

set -e

# Register a fresh instant subdomain (when needed)
if [ ! -f creds.json ]; then
  curl -X POST https://api.getlocalcert.net/api/v1/register > creds.json
fi

# Patch the Caddyfile to use the new subdomain
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain creds.json)
sed "s/YOUR_FQDN_HERE/${ACMEDNS_FULLDOMAIN}/" CaddyfileTemplate > Caddyfile

# Caddy will issue a certificate as it runs
sudo ./caddy run &

