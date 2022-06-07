#!/usr/bin/env bash

set -euo pipefail

LE_EMAIL=${LE_EMAIL}
CERT_MANAGER_VERSION=${CERT_MANAGER_VERSION:-"v1.8.0"}

helm repo add jetstack https://charts.jetstack.io || true
helm repo update

echo "Installing cert-manager..."
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/"$CERT_MANAGER_VERSION"/cert-manager.crds.yaml
helm --namespace cert-manager upgrade \
    --atomic \
    --create-namespace \
    --install \
    --version "$CERT_MANAGER_VERSION" \
    cert-manager jetstack/cert-manager

echo "Deploying Let's Encrypt ClusterIssuer..."
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: "${LE_EMAIL}"
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod-acme-account-key
    solvers:
    - dns01:
        digitalocean:
          tokenSecretRef:
            name: digitalocean-dns
            key: access-token
EOF
