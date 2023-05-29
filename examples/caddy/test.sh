#!/bin/bash

set -e

# Run the example
SCRIPT_PATH=$(dirname "$0")
cp ./caddy ${SCRIPT_PATH}
cd ${SCRIPT_PATH}
./register-and-issue.sh

# Use the Let's Encrypt staging certificates for validation
# You should never do this outside testing as you should use LE's production
if [ ! -f letsencrypt-stg-root-x1.pem ]; then
  wget https://letsencrypt.org/certs/staging/letsencrypt-stg-root-x1.pem
fi

export ACMEDNS_FULLDOMAIN=$(jq -r .fulldomain creds.json)

# Check if it's up
sleep 20
for i in {1..60} ;
do
  echo "waiting..."
  sleep 2

  # localhostcert.net points the domain at localhost out-of-the-box
  if curl --cacert letsencrypt-stg-root-x1.pem https://${ACMEDNS_FULLDOMAIN} > output; then
    cat output | grep "Hello from Caddy"
    if [ $? -eq 0 ]; then
      echo "Success!"
      exit 0
    else
      echo "Got unexpected output:"
      cat output
      echo ""
    fi
  else
    echo "Got a curl error"
  fi
done

echo "Caddy didn't load in time"
exit 1

