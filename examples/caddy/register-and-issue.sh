#!/bin/bash

set -e

# Register a fresh instant subdomain (if needed)
if [ ! -f creds.json ]; then
  curl -X POST https://api.getlocalcert.net/api/v1/register > creds.json
fi

# Patch the Caddyfile to use the new subdomain
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain creds.json)
sed -i "s/YOUR_FQDN_HERE/${ACMEDNS_FULLDOMAIN}/" Caddyfile

# Caddy will issue a certificate as it runs
sudo ./caddy run &

