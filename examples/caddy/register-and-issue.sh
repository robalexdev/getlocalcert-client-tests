#!/bin/bash

set -e

export LOCALCERT_API=https://api.getlocalcert.net/api/v1
export ACMEDNS_BASE_URL=${LOCALCERT_API}/acme-dns-compat

# Register a fresh instant subdomain (if needed)
if [ ! -f creds.json ]; then
  curl -X POST ${LOCALCERT_API}/register > creds.json
fi

# Build a Caddyfile that will use these new credentials
# to perform certificate issuance via ACME DNS-01
export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain creds.json)
cat > Caddyfile << EOF
${ACMEDNS_FULLDOMAIN} {
  tls {
    ca https://acme-staging-v02.api.letsencrypt.org/directory
    dns acmedns creds.json
  }
  respond "Hello from Caddy"
}
EOF

# Caddy will issue a certificate as it runs
sudo ./caddy run &

