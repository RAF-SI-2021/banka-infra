#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="${NAMESPACE}"

# Add Helm repo
helm repo add bitnami https://charts.bitnami.com/bitnami || true

# Refresh Helm repos
helm repo update

# Install MongoDB chart
helm upgrade --install mongodb bitnami/mongodb-sharded \
  --values ./clusters/elab/mongodb/values.yaml \
  --namespace "${NAMESPACE}" \
  --create-namespace
