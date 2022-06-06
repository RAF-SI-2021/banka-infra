#!/usr/bin/env bash

set -euo pipefail

NAMESPACE=${NAMESPACE}

# Add Helm repo
helm repo add influxdata https://helm.influxdata.com || true

# Refresh Helm repos
helm repo update

# Install InfluxDB chart
helm upgrade --install --values ./clusters/elab/influxdb/values.yaml --namespace "${NAMESPACE}" influx influxdata/influxdb2
