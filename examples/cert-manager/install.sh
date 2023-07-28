#!/bin/bash

set -e

# ensure the cluster is up
kind delete cluster
kind create cluster

# install the creds
kubectl create secret generic acme-dns --from-file acmedns.json

# install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml
sleep 45

# tell cert-manager to issue and manage a certificate
kubectl apply -f test-resources.yaml

# it will take some time to issue a certificate
for i in {0..60}
do
  sleep 5
  if kubectl get certificate cert-manager-test -o json | jq .status.conditions[0].message | tee /dev/stderr | grep "Certificate is up to date and has not expired"; then
    echo "Success!"
    exit 0
  fi
done

echo "Certificate wasn't issued correctly"

# Debug
kubectl describe certificaterequest
kubectl describe issuer le-staging-issuer
kubectl describe challenge

exit 1

